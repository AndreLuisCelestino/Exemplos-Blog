unit uFormulario;

{
  Exemplo desenvolvido por André Luis Celestino: www.andrecelestino.com
}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Generics.Collections, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, DBClient, uFuncionario, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TfFormulario = class(TForm)
    CampoCodigo: TEdit;
    CampoNome: TEdit;
    CampoSexo: TRadioGroup;
    CampoEstadoCivil: TComboBox;
    CampoPlanoSaude: TCheckBox;
    CampoSenioridade: TTrackBar;
    LabelCodigo: TLabel;
    LabelNome: TLabel;
    LabelEstadoCivil: TLabel;
    LabelSenioridade: TLabel;
    CampoDataNascimento: TDateTimePicker;
    LabelDataNascimento: TLabel;
    CampoCorUniforme: TShape;
    LabelCorUniforme: TLabel;
    DBGrid1: TDBGrid;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    ClientDataSetNome: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure ClientDataSetAfterScroll(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
  private
    FListaFuncionarios: TObjectList<TFuncionario>;

    procedure PreencherDataSet;
    procedure PreencherCampos(Funcionario: TFuncionario);
    function IncluirFuncionario(Dados: array of variant): TFuncionario;
  end;

var
  fFormulario: TfFormulario;

implementation

uses
  System.RTTI;

{$R *.dfm}

procedure TfFormulario.ClientDataSetAfterScroll(DataSet: TDataSet);
begin
  // Chama o método para preencher os controles visuais da tela,
  // informando o objeto posicionado no índice "RecNo - 1" do ClientDataSet
  PreencherCampos(FListaFuncionarios[Pred(ClientDataSet.RecNo)]);
end;

procedure TfFormulario.FormCreate(Sender: TObject);
begin
  // Cria a lista de objetos
  FListaFuncionarios := TObjectList<TFuncionario>.Create;

  FListaFuncionarios.Add(IncluirFuncionario(['1', 'Hugo Weaving', 'Solteiro(a)', 'Masculino',
    '3', '22/01/1985', clSkyBlue, True]));

  FListaFuncionarios.Add(IncluirFuncionario(['2', 'Sarah Connor', 'Casado(a)', 'Feminino',
    '5', '07/05/1978', clSilver, False]));

  FListaFuncionarios.Add(IncluirFuncionario(['3', 'Lara Croft', 'Viúvo(a)', 'Feminino',
    '9', '18/12/1991', clTeal, True]));

  FListaFuncionarios.Add(IncluirFuncionario(['4', 'Martin Riggs', 'Casado(a)', 'Masculino',
    '2', '30/04/1982', clCream, True]));

  FListaFuncionarios.Add(IncluirFuncionario(['5', 'Tony Stark', 'Divorciado(a)', 'Masculino',
    '4', '05/06/1975', clMoneyGreen, False]));

  FListaFuncionarios.Add(IncluirFuncionario(['6', 'Beatrice Prior', 'Solteiro(a)', 'Feminino',
    '6', '20/07/1993', clPurple, True]));

  FListaFuncionarios.Add(IncluirFuncionario(['7', 'John Mcclane', 'Casado(a)', 'Masculino',
    '1', '11/09/1980', clGreen, False]));

  FListaFuncionarios.Add(IncluirFuncionario(['8', 'Ellie Sattler', 'Solteiro(a)', 'Feminino',
    '8', '27/10/1995', clOlive, False]));

  // Popula o ClientDataSet com os funcionários cadastrados
  PreencherDataSet;
end;

procedure TfFormulario.FormDestroy(Sender: TObject);
begin
  FListaFuncionarios.Free;
end;

function TfFormulario.IncluirFuncionario(Dados: array of variant): TFuncionario;
begin
  result := TFuncionario.Create;
  result.Codigo := Dados[0];
  result.Nome := Dados[1];
  result.EstadoCivil := Dados[2];
  result.Sexo := Dados[3];
  result.Senioridade := Dados[4];
  result.DataNascimento := StrToDate(Dados[5]);
  result.CorUniforme := Dados[6];
  result.PlanoSaude := Dados[7];
end;

procedure TfFormulario.PreencherCampos(Funcionario: TFuncionario);
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  Valor: variant;
  Propriedade: TRttiProperty;
  Componente: TComponent;
begin
  // Cria o contexto do RTTI
  Contexto := TRttiContext.Create;

  // Obtém as informações de RTTI da classe TFuncionario
  Tipo := Contexto.GetType(TFuncionario.ClassInfo);

  try
    // Faz uma iteração nas propriedades do objeto
    for Propriedade in Tipo.GetProperties do
    begin
      // Obtém o valor da propriedade
      Valor := Propriedade.GetValue(Funcionario).AsVariant;

      // Encontra o componente relacionado, como, por exemplo, "CampoNome"
      Componente := FindComponent('Campo' + Propriedade.Name);

      // (Código e nome)
      // Testa se o componente é da classe "TEdit" para acessar a propriedade "Text"
      if Componente is TEdit then
        (Componente as TEdit).Text := Valor;

      // (Estado Civil)
      // Testa se o componente é da classe "TComboBox" para acessar a propriedade "ItemIndex"
      if Componente is TComboBox then
        (Componente as TComboBox).ItemIndex := (Componente as TComboBox).Items.IndexOf(Valor);

      // (Sexo)
      // Testa se o componente é da classe "TRadioGroup" para acessar a propriedade "ItemIndex"
      if Componente is TRadioGroup then
        (Componente as TRadioGroup).ItemIndex := (Componente as TRadioGroup).Items.IndexOf(Valor);

      // (Plano de Saúde)
      // Testa se o componente é da classe "TCheckBox" para acessar a propriedade "Checked"
      if Componente is TCheckBox then
        (Componente as TCheckBox).Checked := Valor;

      // (Senioridade)
      // Testa se o componente é da classe "TTrackBar" para acessar a propriedade "Position"
      if (Componente is TTrackBar) then
        (Componente as TTrackBar).Position := Valor;

      // (Data de Nascimento)
      // Testa se o componente é da classe "TDateTimePicker" para acessar a propriedade "Date"
      if (Componente is TDateTimePicker) then
        (Componente as TDateTimePicker).Date := Valor;

      // (Cor do Uniforme)
      // Testa se o componente é da classe "TShape" para acessar a propriedade "Brush.Color"
      if (Componente is TShape) then
        (Componente as TShape).Brush.Color := Valor;
    end;
  finally
    Contexto.Free;
  end;
end;

procedure TfFormulario.PreencherDataSet;
var
  Contexto: TRttiContext;
  Tipo: TRttiType;
  PropriedadeNome: TRttiProperty;
  Funcionario: TFuncionario;
begin
  // Cria o contexto do RTTI
  Contexto := TRttiContext.Create;
  try
    // Obtém as informações de RTTI da classe TFuncionario
    Tipo := Contexto.GetType(TFuncionario.ClassInfo);

    // Obtém um objeto referente à propriedade "Nome" da classe TFuncionario
    PropriedadeNome := Tipo.GetProperty('Nome');

    // Percorre a lista de objetos, inserindo o valor da propriedade "Nome" do ClientDataSet
    for Funcionario in FListaFuncionarios do
      ClientDataSet.AppendRecord([VarToStr(PropriedadeNome.GetValue(Funcionario).AsVariant)]);

    ClientDataSet.First;
  finally
    Contexto.Free;
  end;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
