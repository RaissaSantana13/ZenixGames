
CREATE OR REPLACE TRIGGER trg_verificar_saldo
BEFORE INSERT ON Pedido
FOR EACH ROW
DECLARE
    v_saldo Usuario.saldo%TYPE;
BEGIN
    SELECT saldo INTO v_saldo
    FROM Usuario
    WHERE id_usuario = :NEW.id_usuario;
    IF v_saldo < :NEW.valor_total THEN
        RAISE_APPLICATION_ERROR(-20001, 'Erro: Saldo insuficiente para realizar a compra.');
    END IF;
END;

CREATE OR REPLACE TRIGGER trg_impedir_jogo_duplicado
BEFORE INSERT ON ItemPedido
FOR EACH ROW
DECLARE
    v_id_usuario Pedido.id_usuario%TYPE;
    v_possui     NUMBER;
BEGIN
    SELECT id_usuario INTO v_id_usuario
    FROM Pedido
    WHERE id_pedido = :NEW.id_pedido;
    SELECT COUNT(*) INTO v_possui
    FROM BibliotecaUsuario
    WHERE id_usuario = v_id_usuario 
      AND id_jogo = :NEW.id_jogo;
    IF v_possui > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Erro: O usuário já possui este jogo em sua biblioteca.');
    END IF;
END;

CREATE OR REPLACE TRIGGER trg_adicionar_biblioteca
AFTER INSERT ON ItemPedido
FOR EACH ROW
DECLARE
    v_id_usuario Pedido.id_usuario%TYPE;
BEGIN
    SELECT id_usuario INTO v_id_usuario
    FROM Pedido
    WHERE id_pedido = :NEW.id_pedido;
    INSERT INTO BibliotecaUsuario (id_usuario, id_jogo)
    VALUES (v_id_usuario, :NEW.id_jogo);
END;

