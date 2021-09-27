-- banco FortesDB.sqlite
-- tb_venda definition
CREATE TABLE tb_venda (
	venda_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	venda_data TEXT NOT NULL,
	venda_bomba INTEGER NOT NULL,
    venda_tanque INTEGER NOT NULL,
    venda_valor NUMERIC NOT NULL,
	venda_total NUMERIC NOT NULL);