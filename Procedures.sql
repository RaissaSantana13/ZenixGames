CREATE OR REPLACE PROCEDURE prc_realizarCompra (
    p_id_usuario IN NUMBER,
    p_id_jogo IN NUMBER,
    p_id_cupom IN NUMBER DEFAULT NULL
)
IS
    v_preco NUMBER;
    v_preco_final NUMBER;
    v_saldo NUMBER;
    v_estoque NUMBER;
    v_id_pedido NUMBER;
    v_existe NUMBER;
    v_desconto NUMBER;
    v_validade DATE;
BEGIN

    SET TRANSACTION READ WRITE;

    SAVEPOINT sp_compra;

    SELECT COUNT(*)
    INTO v_existe
    FROM BibliotecaUsuario
    WHERE id_usuario = p_id_usuario
      AND id_jogo = p_id_jogo;

    IF v_existe > 0 THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'Usuario ja possui este jogo.'
        );
    END IF;

    SELECT preco, estoque_licencas
    INTO v_preco, v_estoque
    FROM Jogo
    WHERE id_jogo = p_id_jogo;

    IF v_estoque <= 0 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Licencas indisponiveis.'
        );
    END IF;

    v_preco_final := v_preco;

    -- Validação do cupom
    IF p_id_cupom IS NOT NULL THEN

        BEGIN

            SELECT desconto, validade
            INTO v_desconto, v_validade
            FROM Cupom
            WHERE id_cupom = p_id_cupom;

            IF v_validade < SYSDATE THEN
                RAISE_APPLICATION_ERROR(
                    -20004,
                    'Cupom expirado.'
                );
            END IF;

            v_preco_final :=
                v_preco - (v_preco * v_desconto / 100);

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(
                    -20005,
                    'Cupom inexistente.'
                );
        END;

    END IF;

    SELECT saldo
    INTO v_saldo
    FROM Usuario
    WHERE id_usuario = p_id_usuario;

    IF v_saldo < v_preco_final THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Saldo insuficiente.'
        );
    END IF;

    INSERT INTO Pedido (
        id_usuario,
        id_cupom,
        valor_total
    )
    VALUES (
        p_id_usuario,
        p_id_cupom,
        v_preco_final
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
    SET saldo = saldo - v_preco_final
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
    WHEN OTHERS THEN
        ROLLBACK TO sp_compra;
        RAISE;
END;


CREATE OR REPLACE PROCEDURE prc_cancelarCompra (
    p_id_pedido IN NUMBER
)
IS
    v_usuario NUMBER;
    v_valor NUMBER;
BEGIN

    SET TRANSACTION READ WRITE;

    SAVEPOINT sp_cancelamento;

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

    DELETE FROM ItemPedido
    WHERE id_pedido = p_id_pedido;

    DELETE FROM Pedido
    WHERE id_pedido = p_id_pedido;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO sp_cancelamento;
        RAISE;
END;
