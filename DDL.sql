DROP TABLE BibliotecaUsuario CASCADE CONSTRAINTS;
DROP TABLE ItemPedido CASCADE CONSTRAINTS;
DROP TABLE Pedido CASCADE CONSTRAINTS;
DROP TABLE Jogo CASCADE CONSTRAINTS;
DROP TABLE Cupom CASCADE CONSTRAINTS;
DROP TABLE Categoria CASCADE CONSTRAINTS;
DROP TABLE Usuario CASCADE CONSTRAINTS;

CREATE TABLE Usuario(
    id_usuario NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome  VARCHAR2(50) NOT NULL,
    email VARCHAR2(50) NOT NULL,
    saldo NUMBER(10,2) DEFAULT 0 
);

CREATE TABLE Categoria (
    id_categoria NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(50) NOT NULL
);

CREATE TABLE Jogo(
    id_jogo NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR2(50) NOT NULL,
    preco NUMBER(10,2) NOT NULL,
    estoque_licencas NUMBER NOT NULL,
    id_categoria NUMBER,
    
    CONSTRAINT fk_jogo_categoria 
        FOREIGN KEY (id_categoria)
        REFERENCES Categoria(id_categoria)
    
);

CREATE TABLE Cupom(
    id_cupom NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    desconto NUMBER(5,2),
    validade DATE NOT NULL
);

CREATE TABLE Pedido(
    id_pedido NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario NUMBER NOT NULL,
    id_cupom NUMBER,
    valor_total NUMBER(10,2) NOT NULL,
    data_pedido DATE DEFAULT SYSDATE,

    CONSTRAINT fk_pedido_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES Usuario(id_usuario),

    CONSTRAINT fk_pedido_cupom
        FOREIGN KEY (id_cupom)
        REFERENCES Cupom(id_cupom)

);

CREATE TABLE ItemPedido (
    id_item NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pedido NUMBER NOT NULL,
    id_jogo NUMBER NOT NULL,
    preco NUMBER(10,2) NOT NULL,

    CONSTRAINT fk_itempedido_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES Pedido(id_pedido),

    CONSTRAINT fk_itempedido_jogo
        FOREIGN KEY (id_jogo)
        REFERENCES Jogo(id_jogo)
);

CREATE TABLE BibliotecaUsuario (

    id_biblioteca NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario NUMBER NOT NULL,
    id_jogo NUMBER NOT NULL,
    data_compra DATE DEFAULT SYSDATE,

    CONSTRAINT uk_usuario_jogo 
        UNIQUE (id_usuario, id_jogo),

    CONSTRAINT fk_biblioteca_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES Usuario(id_usuario),

    CONSTRAINT fk_biblioteca_jogo
        FOREIGN KEY (id_jogo)
        REFERENCES Jogo(id_jogo)
);