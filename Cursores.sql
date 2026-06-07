SET SERVEROUTPUT ON;

DECLARE
    -- Cursor que busca os jogos de um usuário específico
    CURSOR c_jogos_usuario (p_id_usuario Usuario.id_usuario%TYPE) IS
        SELECT j.nome AS nome_jogo, b.data_compra
        FROM BibliotecaUsuario b
        JOIN Jogo j ON b.id_jogo = j.id_jogo
        WHERE b.id_usuario = p_id_usuario;
        
    v_id_teste Usuario.id_usuario%TYPE := 1; -- ID do Hugo Pereira para o teste
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- JOGOS COMPRADOS ---');
    
    FOR r_jogo IN c_jogos_usuario(v_id_teste) LOOP
        DBMS_OUTPUT.PUT_LINE('- ' || r_jogo.nome_jogo || ' (Comprado em: ' || TO_CHAR(r_jogo.data_compra, 'DD/MM/YYYY') || ')');
    END LOOP;
END;


DECLARE
    -- Cursor para listar os pedidos e somar o total
    CURSOR c_pedidos IS
        SELECT id_pedido, valor_total FROM Pedido;
        
    -- Cursor para contar as vendas de cada jogo
    CURSOR c_ranking_jogos IS
        SELECT j.nome AS nome_jogo, COUNT(ip.id_item) AS qtd
        FROM Jogo j
        LEFT JOIN ItemPedido ip ON j.id_jogo = ip.id_jogo
        GROUP BY j.nome
        ORDER BY qtd DESC;

    v_faturamento_total NUMBER(10,2) := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- RESUMO DE VENDAS ---');
    
    -- Parte 1: Listar pedidos e calcular total
    FOR r_pedido IN c_pedidos LOOP
        DBMS_OUTPUT.PUT_LINE('Pedido #' || r_pedido.id_pedido || ' | Valor: R$ ' || r_pedido.valor_total);
        v_faturamento_total := v_faturamento_total + r_pedido.valor_total;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('TOTAL FATURADO: R$ ' || v_faturamento_total);
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Parte 2: Ranking de mais vendidos
    DBMS_OUTPUT.PUT_LINE('--- RANKING DE JOGOS ---');
    FOR r_rank IN c_ranking_jogos LOOP
        DBMS_OUTPUT.PUT_LINE(r_rank.nome_jogo || ': ' || r_rank.qtd || ' vendas');
    END LOOP;
END;
