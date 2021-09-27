unit uConexao;

interface

uses
  System.SysUtils, FireDAC.Stan.Intf, FireDAC.Comp.Client;

type
  TConexao = class
  private
  public
    class function GetCon:TFDConnection;
  end;

implementation


{ TConexao }

class function TConexao.GetCon: TFDConnection;
begin
  result := TFDConnection.Create(nil);
  try
    result.DriverName := 'SQLite';
    result.Params.Database := ExtractFilePath(ParamStr(0)) + 'FortesDB.sqlite';
    result.Connected := True;
  except
    on e:exception do
      Raise Exception.Create('Erro ao conectar ao banco: '+e.Message);
  end;
end;

end.
