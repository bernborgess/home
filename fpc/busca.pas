unit uBuscaProdutos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, ZConnection;

type

  { TfrmBuscaProdutos }
  TfrmBuscaProdutos = class(TForm)
    btnBuscar: TButton;
    cbxCategoria: TComboBox;
    cbxGenero: TComboBox;
    edtNome: TEdit;
    edtPrecoMin: TEdit;
    edtPrecoMax: TEdit;
    lblNome: TLabel;
    lblCategoria: TLabel;
    lblPrecoMin: TLabel;
    lblPrecoMax: TLabel;
    lblGenero: TLabel;
    dsProdutos: TDataSource;
    grdProdutos: TDBGrid;
    zqProdutos: TZQuery;
    zconn: TZConnection;
    procedure btnBuscarClick(Sender: TObject);
  private
    function MontarWhere: string;
    procedure AplicarParametros;
  public
  end;

var
  frmBuscaProdutos: TfrmBuscaProdutos;

implementation

{$R *.lfm}

{ Adiciona um filtro ao WHEREsomente se o campo não estiver vazio }
procedure AdicionarFiltro(var Where: string; const Condicao: string);
begin
  if Where <> '' then
    Where := Where + ' AND ';
  Where := Where + Condicao;
end;

{ Monta a cláusula WHERE dynamisch com base nos campos preenchidos }
function TfrmBuscaProdutos.MontarWhere: string;
var
  Where: string;
begin
  Where := '';

  if edtNome.Text <> '' then
    AdicionarFiltro(Where, 'nome LIKE :nome');

  if cbxCategoria.Text <> '' then
    AdicionarFiltro(Where, 'categoria = :categoria');

  if edtPrecoMin.Text <> '' then
    AdicionarFiltro(Where, 'preco >= :precoMin');

  if edtPrecoMax.Text <> '' then
    AdicionarFiltro(Where, 'preco <= :precoMax');

  if cbxGenero.Text <> '' then
    AdicionarFiltro(Where, 'genero = :genero');

  if Where <> '' then
    Result := ' WHERE ' + Where
  else
    Result := '';
end;

{ Vincula os parâmetros da query aos campos preenchidos }
procedure TfrmBuscaProdutos.AplicarParametros;
begin
  if edtNome.Text <> '' then
    zqProdutos.ParamByName('nome').AsString := '%' + edtNome.Text + '%';

  if cbxCategoria.Text <> '' then
    zqProdutos.ParamByName('categoria').AsString := cbxCategoria.Text;

  if edtPrecoMin.Text <> '' then
    zqProdutos.ParamByName('precoMin').AsFloat := StrToFloatDef(edtPrecoMin.Text, 0);

  if edtPrecoMax.Text <> '' then
    zqProdutos.ParamByName('precoMax').AsFloat := StrToFloatDef(edtPrecoMax.Text, 0);

  if cbxGenero.Text <> '' then
    zqProdutos.ParamByName('genero').AsString := cbxGenero.Text;
end;

{ Evento OnClick do botão Buscar }
procedure TfrmBuscaProdutos.btnBuscarClick(Sender: TObject);
var
  Sql: string;
begin
  Sql := 'SELECT id, nome, categoria, preco, genero, estoque ' +
         'FROM produtos' + MontarWhere +
         ' ORDER BY nome';

  zqProdutos.Close;
  zqProdutos.SQL.Clear;
  zqProdutos.SQL.Text := Sql;
  AplicarParametros;
  zqProdutos.Open;
end;

end.