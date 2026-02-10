unit uSefazSimuladorService;

interface

type
  TSefazSimuladorService = class
  public
    class function simularEnvio: string;
  end;

implementation

uses
  System.SysUtils;

class function TSefazSimuladorService.simularEnvio: string;
var
  retorno: Integer;
begin
  Randomize;
  retorno := Random(3);

  case retorno of
    0: Result := 'AUTORIZADA';
    1: Result := 'REJEITADA';
  else
    Result := 'CONTINGENCIA';
  end;
end;

end.
