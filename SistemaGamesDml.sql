-- INSERTS USUARIO

INSERT INTO Usuario (nome, email, saldo)
VALUES ('Hugo Pereira', 'hugo@gmail.com', 500);

INSERT INTO Usuario (nome, email, saldo)
VALUES ('Maria Silva', 'maria@gmail.com', 300);

INSERT INTO Usuario (nome, email, saldo)
VALUES ('Joao Souza', 'joao@gmail.com', 150);

-- INSERTS CATEGORIA

INSERT INTO Categoria (nome)
VALUES ('RPG');

INSERT INTO Categoria (nome)
VALUES ('FPS');

INSERT INTO Categoria (nome)
VALUES ('Aventura');

INSERT INTO Categoria (nome)
VALUES ('Esportes');

-- INSERTS JOGO

INSERT INTO Jogo (nome, preco, estoque_licencas, id_categoria)
VALUES ('Elden Ring', 250, 100, 1);

INSERT INTO Jogo (nome, preco, estoque_licencas, id_categoria)
VALUES ('Counter Strike 2', 0, 9999, 2);

INSERT INTO Jogo (nome, preco, estoque_licencas, id_categoria)
VALUES ('FIFA 26', 350, 200, 4);

INSERT INTO Jogo (nome, preco, estoque_licencas, id_categoria)
VALUES ('God of War', 200, 150, 3);

INSERT INTO Jogo (nome, preco, estoque_licencas, id_categoria)
VALUES ('Cyberpunk 2077', 180, 80, 1);

-- INSERTS CUPOM

INSERT INTO Cupom (desconto, validade)
VALUES (10, TO_DATE('2026-12-31','YYYY-MM-DD'));

INSERT INTO Cupom (desconto, validade)
VALUES (25, TO_DATE('2026-10-15','YYYY-MM-DD'));

INSERT INTO Cupom (desconto, validade)
VALUES (50, TO_DATE('2026-08-01','YYYY-MM-DD'));

-- INSERTS PEDIDO

INSERT INTO Pedido (id_usuario, id_cupom, valor_total)
VALUES (1, 1, 225);

INSERT INTO Pedido (id_usuario, id_cupom, valor_total)
VALUES (2, NULL, 350);

INSERT INTO Pedido (id_usuario, id_cupom, valor_total)
VALUES (1, 2, 150);

INSERT INTO Pedido (id_usuario, id_cupom, valor_total)
VALUES (3, NULL, 200);

-- INSERTS ITEMPEDIDO

INSERT INTO ItemPedido (id_pedido, id_jogo, preco)
VALUES (1, 1, 250);

INSERT INTO ItemPedido (id_pedido, id_jogo, preco)
VALUES (2, 3, 350);

INSERT INTO ItemPedido (id_pedido, id_jogo, preco)
VALUES (3, 5, 180);

INSERT INTO ItemPedido (id_pedido, id_jogo, preco)
VALUES (4, 4, 200);

INSERT INTO ItemPedido (id_pedido, id_jogo, preco)
VALUES (1, 2, 0);

-- INSERTS BIBLIOTECAUSUARIO

INSERT INTO BibliotecaUsuario (id_usuario, id_jogo)
VALUES (1, 1);

INSERT INTO BibliotecaUsuario (id_usuario, id_jogo)
VALUES (1, 2);

INSERT INTO BibliotecaUsuario (id_usuario, id_jogo)
VALUES (1, 5);

INSERT INTO BibliotecaUsuario (id_usuario, id_jogo)
VALUES (2, 3);

INSERT INTO BibliotecaUsuario (id_usuario, id_jogo)
VALUES (3, 4);

COMMIT;
