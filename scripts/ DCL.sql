
-- 1. CRIAÇÃO DE ROLES (PERFIS DE ACESSO)
-- Criando perfis para separar responsabilidades administrativas do uso da aplicação.
CREATE ROLE role_zenix_admin;
CREATE ROLE role_zenix_app;

-- 2. CONCESSÃO DE PRIVILÉGIOS PARA O PERFIL ADMINISTRATIVO (role_zenix_admin)
-- O administrador possui controle total de manipulação de dados em todas as tabelas.
GRANT SELECT, INSERT, UPDATE, DELETE ON Usuario TO role_zenix_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Categoria TO role_zenix_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Jogo TO role_zenix_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Cupom TO role_zenix_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Pedido TO role_zenix_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON ItemPedido TO role_zenix_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON BibliotecaUsuario TO role_zenix_admin;

-- Privilégios para executar as procedures de negócio
GRANT EXECUTE ON prc_realizarCompra TO role_zenix_admin;
GRANT EXECUTE ON prc_cancelarCompra TO role_zenix_admin;


-- 3. CONCESSÃO DE PRIVILÉGIOS PARA O PERFIL DA APLICAÇÃO CLIENTE (role_zenix_app)
-- Restringe a aplicação de realizar operações deletérias diretas e foca no uso de procedures.
GRANT SELECT ON Jogo TO role_zenix_app;
GRANT SELECT ON Categoria TO role_zenix_app;
GRANT SELECT, UPDATE(saldo) ON Usuario TO role_zenix_app; 
GRANT SELECT ON Cupom TO role_zenix_app;
GRANT SELECT ON BibliotecaUsuario TO role_zenix_app;

-- A aplicação interage com compras e cancelamentos através das regras de negócio embutidas
GRANT EXECUTE ON prc_realizarCompra TO role_zenix_app;
GRANT EXECUTE ON prc_cancelarCompra TO role_zenix_app;






COMMIT;
