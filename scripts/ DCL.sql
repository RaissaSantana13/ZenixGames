CREATE ROLE role_zenix_admin;
CREATE ROLE role_zenix_app;

-- O administrador possui controle total
GRANT SELECT, INSERT, UPDATE, DELETE ON Usuario TO role_zenix_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Categoria TO role_zenix_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Jogo TO role_zenix_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Cupom TO role_zenix_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Pedido TO role_zenix_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON ItemPedido TO role_zenix_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON BibliotecaUsuario TO role_zenix_admin;

GRANT EXECUTE ON prc_realizarCompra TO role_zenix_admin;
GRANT EXECUTE ON prc_cancelarCompra TO role_zenix_admin;

-- Restringe a aplicação de realizar
GRANT SELECT ON Jogo TO role_zenix_app;
GRANT SELECT ON Categoria TO role_zenix_app;
GRANT SELECT, UPDATE(saldo) ON Usuario TO role_zenix_app; 
GRANT SELECT ON Cupom TO role_zenix_app;
GRANT SELECT ON BibliotecaUsuario TO role_zenix_app;

GRANT EXECUTE ON prc_realizarCompra TO role_zenix_app;
GRANT EXECUTE ON prc_cancelarCompra TO role_zenix_app;

COMMIT;
