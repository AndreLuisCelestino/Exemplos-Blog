unit uVisualizadorDataSets;

interface

uses
  ToolsAPI;

type
  TVisualizadorDataSets = class(TInterfacedObject,
    IOTAWizard, IOTAMenuWizard, IOTAThreadNotifier)
  private
    // Vari�vel para identificar se o processamento foi finalizado
    // Neste caso, � o comando "SaveToFile" do ClientDataSet
    FProcessamentoFinalizado: boolean;

    // Abre um formul�rio para visualiza��o os dados
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
  // Cria um formul�rio
  Formulario := TForm.Create(nil);
  try
    // Configura o formul�rio para janela maximizada
    Formulario.WindowState := wsMaximized;

    // Configura o t�tulo do formul�rio
    Formulario.Caption := 'Visualizador de DataSets';

    // Cria um ClientDataSet
    DataSet := TClientDataSet.Create(Formulario);

    // Carrega o arquivo tempor�rio de dados gerado no m�todo "Execute"
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

    // Exibe o formul�rio
    Formulario.ShowModal;
  finally
    // Libera o form�l�rio da mem�ria
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

  // Vari�veis para preencher os par�metros "out" do Evaluate
  CanModify: boolean;
  Endereco: UInt64;
  Tamanho: Cardinal;
  Resultado: Cardinal;
begin
  // O arquivo de dados ser� gravado na pasta tempor�ria do usu�rio
  ArquivoDados := System.IOUtils.TPath.GetTempPath + 'Dados.xml';

  // Obt�m o texto selecionado no editor
  TextoSelecionado := (BorlandIDEServices as IOTAEditorServices).TopView.GetBlock.Text;

  // Monta a express�o que ser� avaliada pelo Debugger.
  // � o mesmo procedimento de selecionar o DataSet,
  // pressionar CTRL + F7 para abrir o Evaluate/Modify e chamar o SaveToFile
  Expressao := Format('%s.SaveToFile(''%s'')', [TextoSelecionado, ArquivoDados]);

  // Obt�m a Thread do servi�o de depura��o
  Thread := (BorlandIDEServices as IOTADebuggerServices).CurrentProcess.CurrentThread;

  // Solicita a avalia��o da express�o
  Retorno := Thread.Evaluate(Expressao, '', 0, CanModify, True, '', Endereco,
    Tamanho, Resultado);

  if Retorno = erDeferred then
  begin
    FProcessamentoFinalizado := False;

    // Adiciona um notificador, retornando um �ndice
    // para que depois possamos remov�-lo
    IndiceNotifier := Thread.AddNotifier(Self);

    // Processa os eventos pendentes do depurador at� que EvaluteComplete seja chamado
    while not FProcessamentoFinalizado do
      (BorlandIDEServices as IOTADebuggerServices).ProcessDebugEvents;

    // Remove o notificador ap�s a conclus�o da avalia��o
    Thread.RemoveNotifier(IndiceNotifier);
  end;

  // Se a avalia��o foi realizada com sucesso, abre o formul�rio
  // para visualiza��o dos dados
  if not (Retorno in [erError, erBusy]) then
    AbrirVisualizador;
end;

function TVisualizadorDataSets.GetIDString: string;
begin
  // Texto de identifica��o do wizard
  result := 'Visualizador de DataSets';
end;

function TVisualizadorDataSets.GetMenuText: string;
begin
  // Texto que aparecer� no menu Help > Help Wizards
  result := 'Visualizar DataSet';
end;

function TVisualizadorDataSets.GetName: string;
begin
  // Nome do wizard, exigido pela IDE
  result := 'Visualizador de DataSets';
end;

function TVisualizadorDataSets.GetState: TWizardState;
begin
  // Indica que o wizard est� habilitado na IDE
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
