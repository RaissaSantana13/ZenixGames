
SELECT * FROM Usuario;
SELECT * FROM Jogo;
SELECT * FROM Pedido;
SELECT * FROM ItemPedido;
SELECT * FROM BibliotecaUsuario;


-- COMPRA COM SUCESSO
SELECT saldo
FROM Usuario
WHERE id_usuario = 2;

SELECT estoque_licencas
FROM Jogo
WHERE id_jogo = 4;

BEGIN
    prc_realizarCompra(2,4);
END;


SELECT saldo
FROM Usuario
WHERE id_usuario = 2;

SELECT *
FROM BibliotecaUsuario
WHERE id_usuario = 2;

SELECT estoque_licencas
FROM Jogo
WHERE id_jogo = 4;

-- SALDO INSUFICIENTE

SELECT saldo
FROM Usuario
WHERE id_usuario = 4;

BEGIN
    prc_realizarCompra(4,6);
END;

-- DESCOBRIR O ÚLTIMO PEDIDO CRIADO

SELECT MAX(id_pedido)
FROM Pedido;


-- CANCELAMENTO COM SUCESSO

BEGIN
    prc_cancelarCompra(5); -- ULTIMO PEDIDO CRIADO
END;


SELECT saldo
FROM Usuario
WHERE id_usuario = 2;

SELECT *
FROM BibliotecaUsuario
WHERE id_usuario = 2;

SELECT estoque_licencas
FROM Jogo
WHERE id_jogo = 4;

-- CANCELAMENTO DE PEDIDO QUE NÃO EXISTE
BEGIN
    prc_cancelarCompra(999);
END;

-- SEM ESTOQUE
BEGIN
    prc_realizarCompra(5,7);
END;