--Teste da trigger verifica saldo
--Pobre
INSERT INTO Pedido (id_usuario, id_cupom, valor_total)
VALUES (4, NULL, 300);
 
 --Com Grana
INSERT INTO Pedido (id_usuario, id_cupom, valor_total)
VALUES (4, NULL, 40);
SELECT * FROM Pedido WHERE id_usuario = 4;

--teste trigger jogo duplicado 
-- Primeira compra e inserção auto
INSERT INTO ItemPedido (id_pedido, id_jogo, preco)
VALUES (4, 3, 180);

SELECT * FROM BibliotecaUsuario WHERE id_usuario = 3;

-- teste duplicado 
INSERT INTO ItemPedido (id_pedido, id_jogo, preco)
VALUES (4, 3, 180);

