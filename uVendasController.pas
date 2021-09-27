unit uVendasController;

interface

uses
  System.SysUtils, Data.DB, FireDAC.Comp.Client, System.TypInfo, uVendasDTO, uVendasDAO;

type
  TVendaController = class
  private
  public
    class function NovaVenda(const bomba: Integer =-1; const valor: Real = 0) : string;
    class procedure BuscaVendas( const data_inicio,data_final : TDate; var cds : TFDMemTable);
  end;

implementation

{ TVendaController }

class procedure TVendaController.BuscaVendas(const data_inicio, data_final: TDate; var cds: TFDMemTable);
var lista : TVendas;
        i : integer;
begin
  cds.EmptyDataSet;
  lista := TVendas.Create;
  try
    lista := TVendaDAO.GetVendas(data_inicio, data_final);
    for i := 0 to lista.vendas.Count-1 do
    begin
      cds.Append;
      cds.FieldByName('venda_id').AsInteger     := lista.vendas[i].venda_id;
      cds.FieldByName('venda_data').AsString    := lista.vendas[i].venda_data;
      cds.FieldByName('venda_bomba').AsInteger  := lista.vendas[i].venda_bomba;
      cds.FieldByName('venda_tanque').AsInteger := lista.vendas[i].venda_tanque;
      cds.FieldByName('venda_valor').AsCurrency := lista.vendas[i].venda_valor;
      cds.FieldByName('venda_total').AsCurrency := lista.vendas[i].venda_total;
      cds.Post;
    end;
  finally
    lista.DisposeOf;
  end;
end;

class function TVendaController.NovaVenda(const bomba: Integer;const valor: Real): string;
var venda : TVenda;
begin
  if valor = 0 then
  begin
    result := 'não é possivel realizar uma venda com valor zero!';
    Exit;
  end
  else
  try
    venda  := TVenda.Create( bomba, valor );
    Result := TVendaDAO.PostVenda(venda);
  finally
    venda.DisposeOf;
  end;
end;

end.
