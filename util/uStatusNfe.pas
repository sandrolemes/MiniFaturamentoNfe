unit uStatusNfe;

interface

type
  TNfeStatus = (
    nsRascunho,
    nsProntaParaEnvio,
    nsEnviada,
    nsAutorizada,
    nsRejeitada,
    nsCancelada,
    nsContingencia
  );

function nfeStatusToString(pStatus: TNfeStatus): string;
function stringToNfeStatus(pValue: string): TNfeStatus;

implementation

uses
  System.SysUtils;

function nfeStatusToString(pStatus: TNfeStatus): string;
begin
  case pStatus of
    nsRascunho: Result := 'RASCUNHO';
    nsProntaParaEnvio: Result := 'PRONTA_PARA_ENVIO';
    nsEnviada: Result := 'ENVIADA';
    nsAutorizada: Result := 'AUTORIZADA';
    nsRejeitada: Result := 'REJEITADA';
    nsContingencia: Result := 'CONTINGENCIA';
    nsCancelada: Result := 'CANCELADA';
  else
    Result := 'RASCUNHO';
  end;
end;

function stringToNfeStatus(pValue: string): TNfeStatus;
var
  v: string;
begin
  v := UpperCase(Trim(pValue));

  if v = 'RASCUNHO' then Exit(nsRascunho);
  if v = 'PRONTA_PARA_ENVIO' then Exit(nsProntaParaEnvio);
  if v = 'ENVIADA' then Exit(nsEnviada);
  if v = 'AUTORIZADA' then Exit(nsAutorizada);
  if v = 'REJEITADA' then Exit(nsRejeitada);
  if v = 'CONTINGENCIA' then Exit(nsContingencia);
  if v = 'CANCELADA' then Exit(nsCancelada);

  Result := nsRascunho;
end;

end.
