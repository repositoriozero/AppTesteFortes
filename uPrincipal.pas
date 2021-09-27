unit uPrincipal;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Samples.Spin, Vcl.Buttons, Vcl.DBGrids, RLReport, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, Vcl.Grids,
  Vcl.Imaging.pngimage;

type
  TfmPrincipal = class(TForm)
    pgPrincipal: TPageControl;
    tsVenda: TTabSheet;
    tsConsulta: TTabSheet;
    pnlCor: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbBomba: TComboBox;
    edTotal: TEdit;
    btConfirma: TButton;
    btLimpa: TButton;
    edLitros: TSpinEdit;
    Label4: TLabel;
    edPreco: TEdit;
    Image2: TImage;
    Panel1: TPanel;
    edDataInicio: TDateTimePicker;
    edDataFim: TDateTimePicker;
    Label5: TLabel;
    Label6: TLabel;
    btImprimir: TSpeedButton;
    DBGrid1: TDBGrid;
    tsRelatorio: TTabSheet;
    mVendas_: TFDMemTable;
    dsVendas_: TDataSource;
    mVendas_venda_id: TIntegerField;
    mVendas_venda_data: TStringField;
    mVendas_venda_bomba: TIntegerField;
    mVendas_venda_tanque: TIntegerField;
    mVendas_venda_valor: TCurrencyField;
    mVendas_venda_total: TCurrencyField;
    btPesquisar: TSpeedButton;
    RLReport1: TRLReport;
    RLBand1: TRLBand;
    RLGroup1: TRLGroup;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLBand4: TRLBand;
    RLBand5: TRLBand;
    RLLabel1: TRLLabel;
    RLImage1: TRLImage;
    RLDBText2: TRLDBText;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    RLDBText6: TRLDBText;
    RLLabel2: TRLLabel;
    RLDBResult1: TRLDBResult;
    RLDBResult2: TRLDBResult;
    RLLabel8: TRLLabel;
    RLDBResult3: TRLDBResult;
    RLDBResult4: TRLDBResult;
    RLSystemInfo1: TRLSystemInfo;
    RLBand6: TRLBand;
    RLSystemInfo2: TRLSystemInfo;
    RLSystemInfo3: TRLSystemInfo;
    RLLabel9: TRLLabel;
    RLLabel10: TRLLabel;
    procedure btLimpaClick(Sender: TObject);
    procedure cbBombaChange(Sender: TObject);
    procedure AtualizaTotal(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btConfirmaClick(Sender: TObject);
    procedure btPesquisarClick(Sender: TObject);
    procedure btImprimirClick(Sender: TObject);
  private
    const preco_gasolina = 4.9986;
    const preco_diesel   = 4.6279;
    var preco : Currency;
  public
  end;

var
  fmPrincipal: TfmPrincipal;

implementation

uses
  uVendasController;

{$R *.dfm}

procedure TfmPrincipal.AtualizaTotal(Sender: TObject);
begin
  edPreco.Text := FormatFloat('###,##0.0000', preco );
  try
    edTotal.Text := FormatFloat('###,##0.0000', (preco*edLitros.Value) );
  except
    edTotal.Text := '0.00';
  end;
end;

procedure TfmPrincipal.btConfirmaClick(Sender: TObject);
var r : string;
begin
  r := TVendaController.NovaVenda( cbBomba.ItemIndex+1, (preco*edLitros.Value) );
  if r = '' then
  begin
    btLimpa.OnClick(Sender);
    ShowMessage('Registro gravado com sucesso!');
  end
  else
    ShowMessage(r);
end;

procedure TfmPrincipal.btImprimirClick(Sender: TObject);
begin
  if mVendas_.RecordCount = 0 then
    ShowMessage('Sem dados para imprimir..')
  else
  begin
    RLReport1.Prepare;
    RLReport1.PreviewModal;
  end;
end;

procedure TfmPrincipal.btLimpaClick(Sender: TObject);
begin
  edLitros.Value    := 0;
  edTotal.Text      := '0,00';
  edLitros.SetFocus;
end;

procedure TfmPrincipal.btPesquisarClick(Sender: TObject);
begin
  TVendaController.BuscaVendas(edDataInicio.DateTime, edDataFim.DateTime, mVendas_);
end;

procedure TfmPrincipal.cbBombaChange(Sender: TObject);
begin
  if cbBomba.ItemIndex in [0,1] then
  begin
    pnlCor.Color := $0080FF80; // gasolina
    preco := preco_gasolina;
  end
  else
  begin
    pnlCor.Color := $0080FFFF; // diesel
    preco := preco_diesel;
  end;
  AtualizaTotal(sender);
end;

procedure TfmPrincipal.FormCreate(Sender: TObject);
begin
  tsRelatorio.TabVisible := False;
  cbBomba.ItemIndex := 0;
  cbBomba.OnChange(Sender);
  edDataInicio.Date := Now;
  edDataFim.Date := Now;
  pgPrincipal.ActivePageIndex := 0;
  mVendas_.CreateDataSet;
end;

end.
