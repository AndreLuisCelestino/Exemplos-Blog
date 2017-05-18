unit uVisualizadorDataSets;

interface

uses
  ToolsAPI;

type
  TVisualizadorDataSets = class(TInterfacedObject,
    IOTAWizard, IOTAMenuWizard, IOTAThreadNotifier)
  private
    // Variável para identificar se o processamento foi finalizado
    // Neste caso, é o comando "SaveToFile" do ClientDataSet
    FProcessamentoFinalizado: boolean;

    // Abre um formulário para visualização os dados
    procedure AbrirVisualizador;

    { Assinaturas do IOTAWizard }
    function GetState: TWizardState;
    function GetIDString: string;
    function GetName: string;
    procedure AfterSave;
    procedure BeforeSave;
    procedure Destroyed;
    procedure Execute;
    procedure Modified;

    { Assinatura da Interface IOTAMenuWizard }
    function GetMenuText: string;

    { Assinaturas do IOTAThreadNotifier }
    procedure EvaluteComplete(const ExprStr: string; const ResultStr: string;
      CanModify: Boolean; ResultAddress: Cardinal; ResultSize: Cardinal; ReturnCode: Integer);
    procedure ModifyComplete(const ExprStr: string; const ResultStr: string; ReturnCode: Integer);
    procedure ThreadNotify(Reason: TOTANotifyReason);
  end;

procedure Register;

implementation

uses
  System.SysUtils, System.IOUtils, Vcl.Forms, Datasnap.DBClient, Data.DB, Vcl.DBGrids,
  Vcl.Controls;

procedure Register;
begin
  // Registra o Wizard
  RegisterPackageWizard(TVisualizadorDataSets.Create);
end;

{ TVisualizadorDataSets }

procedure TVisualizadorDataSets.AbrirVisualizador;
var
  ArquivoDados: string;
  Formulario: TForm;
  DBGrid: TDBGrid;
  DataSet: TClientDataSet;
  DataSource: TDataSource;
begin
  // Cria um formulário
  Formulario := TForm.Create(nil);
  try
    // Configura o formulário para janela maximizada
    Formulario.WindowState := wsMaximized;

    // Configura o título do formulário
    Formulario.Caption := 'Visualizador de DataSets';

    // Cria um ClientDataSet
    DataSet := TClientDataSet.Create(Formulario);

    // Carrega o arquivo temporário de dados gerado no método "Execute"
    ArquivoDados := System.IOUtils.TPath.GetTempPath + 'Dados.xml';
    DataSet.LoadFromFile(ArquivoDados);

    // Cria um DataSource e o aponta para o ClientDataSet
    DataSource := TDataSource.Create(Formulario);
    DataSource.DataSet := DataSet;

    // Cria um DBGrid e o aponta para o DataSource
    DBGrid := TDBGrid.Create(Formulario);
    DBGrid.Parent := Formulario;
    DBGrid.Align := alClient;
    DBGrid.DataSource := DataSource;

    // Exibe o formulário
    Formulario.ShowModal;
  finally
    // Libera o formúlário da memória
    Formulario.Free;
  end;
end;

procedure TVisualizadorDataSets.Execute;
var
  ArquivoDados: string;
  TextoSelecionado: string;
  Expressao: string;
  Thread: IOTAThread;
  Retorno: TOTAEvaluateResult;
  IndiceNotifier: integer;

  // Variáveis para preencher os parâmetros "out" do Evaluate
  CanModify: boolean;
  Endereco: UInt64;
  Tamanho: Cardinal;
  Resultado: Cardinal;
begin
  // O arquivo de dados será gravado na pasta temporária do usuário
  ArquivoDados := System.IOUtils.TPath.GetTempPath + 'Dados.xml';

  // Obtém o texto selecionado no editor
  TextoSelecionado := (BorlandIDEServices as IOTAEditorServices).TopView.GetBlock.Text;

  // Monta a expressão que será avaliada pelo Debugger.
  // É o mesmo procedimento de selecionar o DataSet,
  // pressionar CTRL + F7 para abrir o Evaluate/Modify e chamar o SaveToFile
  Expressao := Format('%s.SaveToFile(''%s'')', [TextoSelecionado, ArquivoDados]);

  // Obtém a Thread do serviço de depuração
  Thread := (BorlandIDEServices as IOTADebuggerServices).CurrentProcess.CurrentThread;

  // Solicita a avaliação da expressão
  Retorno := Thread.Evaluate(Expressao, '', 0, CanModify, True, '', Endereco,
    Tamanho, Resultado);

  if Retorno = erDeferred then
  begin
    FProcessamentoFinalizado := False;

    // Adiciona um notificador, retornando um índice
    // para que depois possamos removê-lo
    IndiceNotifier := Thread.AddNotifier(Self);

    // Processa os eventos pendentes do depurador até que EvaluteComplete seja chamado
    while not FProcessamentoFinalizado do
      (BorlandIDEServices as IOTADebuggerServices).ProcessDebugEvents;

    // Remove o notificador após a conclusão da avaliação
    Thread.RemoveNotifier(IndiceNotifier);
  end;

  // Se a avaliação foi realizada com sucesso, abre o formulário
  // para visualização dos dados
  if not (Retorno in [erError, erBusy]) then
    AbrirVisualizador;
end;

function TVisualizadorDataSets.GetIDString: string;
begin
  // Texto de identificação do wizard
  result := 'Visualizador de DataSets';
end;

function TVisualizadorDataSets.GetMenuText: string;
begin
  // Texto que aparecerá no menu Help > Help Wizards
  result := 'Visualizar DataSet';
end;

function TVisualizadorDataSets.GetName: string;
begin
  // Nome do wizard, exigido pela IDE
  result := 'Visualizador de DataSets';
end;

function TVisualizadorDataSets.GetState: TWizardState;
begin
  // Indica que o wizard está habilitado na IDE
  result := [wsEnabled];
end;

procedure TVisualizadorDataSets.EvaluteComplete(const ExprStr, ResultStr: string;
  CanModify: Boolean; ResultAddress, ResultSize: Cardinal; ReturnCode: Integer);
begin
  FProcessamentoFinalizado := True;
end;

{$REGION 'Demais assinaturas da Interface IOTAWizard'}
procedure TVisualizadorDataSets.AfterSave;
begin

end;

procedure TVisualizadorDataSets.BeforeSave;
begin

end;

procedure TVisualizadorDataSets.Destroyed;
begin

end;

procedure TVisualizadorDataSets.Modified;
begin

end;
{$ENDREGION}

{$REGION 'Demais assinaturas da Interface IOTAThreadNotifier'}
procedure TVisualizadorDataSets.ModifyComplete(const ExprStr, ResultStr: string;
  ReturnCode: Integer);
begin

end;

procedure TVisualizadorDataSets.ThreadNotify(Reason: TOTANotifyReason);
begin

end;
{$ENDREGION}

end.
