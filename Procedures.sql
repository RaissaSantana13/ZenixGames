CREATE OR REPLACE PROCEDURE prc_realizarCompra (
    p_id_usuario IN NUMBER,
    p_id_jogo IN NUMBER
)
IS
    v_preco Usuario.saldo%TYPE;
    v_saldo Usuario.saldo%TYPE;
    v_estoque NUMBER;
    v_id_pedido NUMBER;
BEGIN

    SELECT preco, estoque_licencas
    INTO v_preco, v_estoque
    FROM Jogo
    WHERE id_jogo = p_id_jogo;

    IF v_estoque <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Licenças indisponíveis.');
    END IF;

    SELECT saldo
    INTO v_saldo
    FROM Usuario
    WHERE id_usuario = p_id_usuario;

    IF v_saldo < v_preco THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Saldo insuficiente.');
    END IF;

    INSERT INTO Pedido (
        id_usuario,
        valor_total
    )
    VALUES (
        p_id_usuario,
        v_preco
    )
    RETURNING id_pedido INTO v_id_pedido;

    INSERT INTO ItemPedido (
        id_pedido,
        id_jogo,
        preco
    )
    VALUES (
        v_id_pedido,
        p_id_jogo,
        v_preco
    );

    UPDATE Usuario
    SET saldo = saldo - v_preco
    WHERE id_usuario = p_id_usuario;

    INSERT INTO BibliotecaUsuario (
        id_usuario,
        id_jogo
    )
    VALUES (
        p_id_usuario,
        p_id_jogo
    );

    UPDATE Jogo
    SET estoque_licencas = estoque_licencas - 1
    WHERE id_jogo = p_id_jogo;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN ROLLBACK; RAISE;
END;


CREATE OR REPLACE PROCEDURE prc_cancelarCompra (
    p_id_pedido IN NUMBER
)
IS
    v_usuario NUMBER;
    v_valor NUMBER;
BEGIN

    SELECT id_usuario, valor_total
    INTO v_usuario, v_valor
    FROM Pedido
    WHERE id_pedido = p_id_pedido;

    DELETE FROM BibliotecaUsuario
    WHERE (id_usuario, id_jogo) IN (
        SELECT p.id_usuario, ip.id_jogo
        FROM Pedido p
        JOIN ItemPedido ip
            ON p.id_pedido = ip.id_pedido
        WHERE p.id_pedido = p_id_pedido
    );

    UPDATE Jogo
    SET estoque_licencas = estoque_licencas + 1
    WHERE id_jogo IN (
        SELECT id_jogo
        FROM ItemPedido
        WHERE id_pedido = p_id_pedido
    );

    UPDATE Usuario
    SET saldo = saldo + v_valor
    WHERE id_usuario = v_usuario;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN ROLLBACK; RAISE;
END;

