unit uFuncionario;

interface

uses
  Vcl.Graphics;

type
  TFuncionario = class
  private
    FCodigo: integer;
    FNome: string;
    FEstadoCivil: string;
    FSexo: string;
    FSenioridade: integer;
    FDataNascimento: TDateTime;
    FCorUniforme: TColor;
    FPlanoSaude: boolean;
  public
    property Codigo: integer read FCodigo write FCodigo;
    property Nome: string read FNome write FNome;
    property EstadoCivil: string read FEstadoCivil write FEstadoCivil;
    property Sexo: string read FSexo write FSexo;
    property Senioridade: integer read FSenioridade write FSenioridade;
    property DataNascimento: TDateTime read FDataNascimento write FDataNascimento;
    property CorUniforme: TColor read FCorUniforme write FCorUniforme;
    property PlanoSaude: boolean read FPlanoSaude write FPlanoSaude;
  end;

implementation

end.
