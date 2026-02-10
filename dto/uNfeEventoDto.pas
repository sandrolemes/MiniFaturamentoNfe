unit uNfeEventoDto;

interface

uses
  System.SysUtils;

type
  TNfeEventoDto = class
  private
    fIdNfeEvento: Integer;
    fIdNfe: Integer;
    fDtEvento: TDateTime;
    fStatusAntes: string;
    fStatusDepois: string;
    fMotivo: string;
  public
    property idNfeEvento: Integer read fIdNfeEvento write fIdNfeEvento;
    property idNfe: Integer read fIdNfe write fIdNfe;
    property dtEvento: TDateTime read fDtEvento write fDtEvento;
    property statusAntes: string read fStatusAntes write fStatusAntes;
    property statusDepois: string read fStatusDepois write fStatusDepois;
    property motivo: string read fMotivo write fMotivo;
  end;

implementation

end.
