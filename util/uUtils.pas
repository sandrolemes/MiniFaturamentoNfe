unit uUtils;

interface

uses
  System.SysUtils, 
  Vcl.StdCtrls;

  procedure editMoedaKeyPress(pEdit: TEdit; var pKey: Char);


implementation

procedure editMoedaKeyPress(pEdit: TEdit; var pKey: Char);
var
  vValor: Currency;
  vTexto: string;
begin
  // Permite apenas números e backspace
  if not (pKey in ['0'..'9', #8]) then
  begin
    pKey := #0;
    Exit;
  end;

  // Remove formatação atual
  vTexto := pEdit.Text;
  vTexto := StringReplace(vTexto, 'R$', '', [rfReplaceAll]);
  vTexto := StringReplace(vTexto, '.', '', [rfReplaceAll]);
  vTexto := StringReplace(vTexto, ',', '', [rfReplaceAll]);
  vTexto := Trim(vTexto);

  if pKey = #8 then
    Delete(vTexto, Length(vTexto), 1)
  else
    vTexto := vTexto + pKey;

  if vTexto = '' then
    vValor := 0
  else
    vValor := StrToCurr(vTexto) / 100;

  pEdit.Text := FormatCurr(',0.00', vValor);
  pEdit.SelStart := Length(pEdit.Text);

  pKey := #0;
end;


end.


