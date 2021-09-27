unit uVendasDTO;

interface

uses
  System.SysUtils, System.Generics.Collections, System.TypInfo;

type
  TVenda = class
  private
    Fvenda_id : integer;
    Fvenda_data : string;
    Fvenda_tanque : integer;
    Fvenda_bomba : integer;
    Fvenda_valor : Real;
    Fvenda_total : Real;
  public
    constructor Create(const bomba: Integer =-1; const valor: Real = 0);
    destructor Destroy; override;
    function Gravar:string;
    property venda_id : integer read Fvenda_id write Fvenda_id;
    property venda_data : string read Fvenda_data write Fvenda_data;
    property venda_tanque : integer read Fvenda_tanque write Fvenda_tanque;
    property venda_bomba : integer read Fvenda_bomba write Fvenda_bomba;
    property venda_valor : Real read Fvenda_valor write Fvenda_valor;
    property venda_total : Real read Fvenda_total write Fvenda_total;
  end;

  TVendas = class
  private
    Fvendas : TObjectList<TVenda>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure adicionar(venda_id:Integer; venda_data:string; venda_tanque,venda_bomba:Integer; venda_valor,venda_total:Real );
    property vendas : TObjectList<TVenda> read Fvendas write Fvendas;
  end;

implementation



{ TVenda }

constructor TVenda.Create(const bomba: Integer =-1; const valor: Real = 0);
begin
  if valor <> 0 then
  begin
    Fvenda_id    := 0;
    Fvenda_bomba := bomba;
    Fvenda_valor := valor;
    case bomba of
      1 : Fvenda_tanque := 1;
      2 : Fvenda_tanque := 1;
      3 : Fvenda_tanque := 2;
      4 : Fvenda_tanque := 2;
    end;
    Fvenda_total := valor + (valor * 0.13);
    Fvenda_data  := FormatDateTime('DD/MM/YYYY',now);
  end;
end;

destructor TVenda.Destroy;
begin
  inherited;
end;

function TVenda.Gravar : string;
begin
end;

{ TVendas }

procedure TVendas.adicionar(venda_id:Integer; venda_data: string; venda_tanque,
  venda_bomba: Integer; venda_valor, venda_total: Real);
var i : integer;
begin
  Fvendas.Add( TVenda.Create );
  i := Fvendas.Count-1;
  Fvendas[i].venda_id     := venda_id;
  Fvendas[i].venda_data   := venda_data;
  Fvendas[i].venda_tanque := venda_tanque;
  Fvendas[i].venda_bomba  := venda_bomba;
  Fvendas[i].venda_valor  := venda_valor;
  Fvendas[i].venda_total  := venda_total;
end;

constructor TVendas.Create;
begin
  Fvendas := TObjectList<TVenda>.Create;
end;

destructor TVendas.Destroy;
begin
  FreeAndNil(Fvendas);
  inherited;
end;

end.
