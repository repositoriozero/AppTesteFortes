unit uVendasDAO;

interface

uses
  System.SysUtils, System.Variants, System.Classes, FireDAC.DApt, FireDAC.Stan.Def, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Async, Data.DB,
  FireDAC.Comp.Client, System.Rtti, System.TypInfo, uVendasDTO, uConexao;

type
  TVendaDAO = class
    private
      class procedure ClassToQry(var qry: TFDQuery; obj: TVenda);
      const sql_venda =
              'INSERT INTO tb_venda (venda_data, venda_bomba, venda_tanque, venda_valor, venda_total) '+
              'VALUES(:venda_data, :venda_bomba, :venda_tanque, :venda_valor, :venda_total)';
      const sql_consulta =
              'select venda_id, venda_data, venda_bomba, venda_tanque, cast(venda_valor as float) as venda_valor, cast(venda_total as float) as venda_total '+
              'from tb_venda tv where tv.venda_data between :data_inicial and :data_final order by venda_data, venda_tanque, venda_bomba';
    public
      class function PostVenda(venda:TVenda):String;
      class function GetVendas(const data_inicio,data_final : TDate):TVendas;
  end;

implementation

{ TVendaDAO }

class procedure TVendaDAO.ClassToQry(var qry: TFDQuery; obj: TVenda);
var
  ctx: TRttiContext;
  prop: TRttiProperty;
  valor : Variant;
begin
  ctx := TRttiContext.Create;
  try
    for prop in ctx.GetType(obj.ClassInfo).GetProperties do
    begin
      if prop.PropertyType.TypeKind in [tkInteger] then
        valor := prop.GetValue(obj).AsInteger
      else
      if prop.PropertyType.TypeKind in [tkFloat] then
        valor := prop.GetValue(obj).AsCurrency
      else
        valor := prop.GetValue(obj).AsString;

      if (qry.FindField(prop.Name) <> nil) then
        qry.FieldByName( prop.Name ).Value := valor
      else
      if (qry.FindParam(prop.Name) <> nil) then
        qry.ParamByName( prop.Name ).Value := valor;
    end;
  finally
    ctx.Free;
  end;
end;

class function TVendaDAO.GetVendas(const data_inicio, data_final: TDate): TVendas;
var con : TFDConnection;
    qry : TFDQuery;
begin
  // busca vendas para o relatorio
  con := TConexao.GetCon;
  qry := TFDQuery.Create(nil);
  qry.DisableControls;
  try
    qry.Connection := con;
    qry.SQL.Text := sql_consulta;
    qry.ParamByName('data_inicial').AsString := DateToStr(data_inicio);
    qry.ParamByName('data_final').AsString   := DateToStr(data_final);
    with qry.FormatOptions.MapRules.Add do
    begin
      SourceDataType := dtCurrency;
      TargetDataType := dtBCD;
    end;
    qry.Open;

    while not qry.Eof do
    begin
      Result.adicionar(
        qry.FieldByName('venda_id').AsInteger,
        qry.FieldByName('venda_data').AsString,
        qry.FieldByName('venda_tanque').AsInteger,
        qry.FieldByName('venda_bomba').AsInteger,
        qry.FieldByName('venda_valor').AsCurrency,
        qry.FieldByName('venda_total').AsCurrency);
      qry.Next;
    end;
  finally
    qry.DisposeOf;
    con.DisposeOf;
  end;
end;

class function TVendaDAO.PostVenda(venda: TVenda): String;
var con : TFDConnection;
    qry : TFDQuery;
begin
  // grava venda
  result := '';
  con := TConexao.GetCon;
  qry := TFDQuery.Create(nil);
  qry.DisableControls;
  try
    qry.Connection := con;
    qry.SQL.Text := sql_venda;
    try
      ClassToQry(qry,venda);
      qry.ExecSQL;
    except
      on e:exception do
        result := 'Erro ao gravar: '+e.Message;
    end;
  finally
    qry.DisposeOf;
    con.DisposeOf;
  end;
end;

end.
