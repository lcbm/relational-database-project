DROP DATABASE IF EXISTS comportamento_digital;
CREATE DATABASE IF NOT EXISTS comportamento_digital;
USE comportamento_digital;

CREATE TABLE Pessoa (
  data_nascimento    DATE          NOT NULL,
  sexo               CHAR(1)       NOT NULL,
  cpf                CHAR(11)      NOT NULL,
  rg                 VARCHAR(15)   NOT NULL,
  identidade_genero  VARCHAR(50)   NOT NULL,
  nome               VARCHAR(255)  NOT NULL,
  CONSTRAINT pessoa_pk
    PRIMARY KEY (cpf)
);

CREATE TABLE Telefone (
  cpf       CHAR(11)     NOT NULL,
  telefone  VARCHAR(15)  NOT NULL,
  CONSTRAINT telefone_pk
    PRIMARY KEY (telefone),
  CONSTRAINT telefone_fk
    FOREIGN KEY (cpf)
      REFERENCES Pessoa (cpf)
);

CREATE TABLE Email (
  cpf      CHAR(11)     NOT NULL,
  dominio  VARCHAR(50)  NOT NULL,
  CONSTRAINT email_pk
    PRIMARY KEY (dominio),
  CONSTRAINT email_fk
    FOREIGN KEY (cpf)
      REFERENCES Pessoa (cpf)
);

CREATE TABLE Endereco (
  cep     CHAR(8)      NOT NULL,
  regiao  VARCHAR(50)  NOT NULL,
  estado  VARCHAR(50)  NOT NULL,
  cidade  VARCHAR(50)  NOT NULL,
  bairro  VARCHAR(50)  NOT NULL,
  rua     VARCHAR(50)  NOT NULL,
  CONSTRAINT endereco_pk
    PRIMARY KEY (cep)
);

CREATE TABLE Endereco_Pessoa (
  id_endereco_pessoa  INT          NOT NULL  AUTO_INCREMENT,
  numero              INT          NOT NULL,
  cep                 CHAR(8)      NOT NULL,
  cpf                 CHAR(11)     NOT NULL,
  complemento         VARCHAR(50),
  CONSTRAINT endereco_pessoa_pk
    PRIMARY KEY (id_endereco_pessoa),
  CONSTRAINT endereco_pessoa_cep_fk
    FOREIGN KEY (cep)
      REFERENCES Endereco (cep),
  CONSTRAINT endereco_pessoa_cpf_fk
    FOREIGN KEY (cpf)
      REFERENCES Pessoa (cpf)
);

CREATE TABLE Banco (
  codigo_banco  INT           NOT NULL,
  cnpj          VARCHAR(14)   NOT NULL,
  nome          VARCHAR(255)  NOT NULL,
  CONSTRAINT banco_pk
    PRIMARY KEY (codigo_banco)
);

CREATE TABLE Agencia (
  codigo_banco    INT          NOT NULL,
  codigo_agencia  INT          NOT NULL,
  telefone        VARCHAR(15)  NOT NULL,
  CONSTRAINT agencia_pk
    PRIMARY KEY (codigo_banco, codigo_agencia),
  CONSTRAINT agencia_banco_fk
    FOREIGN KEY (codigo_banco)
      REFERENCES Banco (codigo_banco)
);

CREATE TABLE Endereco_Agencia (
  numero          INT          NOT NULL,
  codigo_banco    INT          NOT NULL,
  codigo_agencia  INT          NOT NULL,
  cep             CHAR(8)      NOT NULL,
  complemento     VARCHAR(50),
  CONSTRAINT endereco_agencia_pk
    PRIMARY KEY (cep, codigo_banco, codigo_agencia),
  CONSTRAINT endereco_agencia_fk
    FOREIGN KEY (codigo_banco, codigo_agencia)
      REFERENCES Agencia (codigo_banco, codigo_agencia),
  CONSTRAINT endereco_cep_fk
    FOREIGN KEY (cep)
      REFERENCES Endereco (cep)
);

CREATE TABLE Categoria (
  id_categoria  INT           NOT NULL  AUTO_INCREMENT,
  nome          VARCHAR(255)  NOT NULL,
  CONSTRAINT categoria_pk
    PRIMARY KEY (id_categoria)
);

CREATE TABLE Website (
  id_categoria  INT           NOT NULL,
  link          VARCHAR(255)  NOT NULL,
  CONSTRAINT website_pk
    PRIMARY KEY (link),
  CONSTRAINT website_fk
    FOREIGN KEY (id_categoria)
      REFERENCES Categoria (id_categoria)
);

CREATE TABLE Visita (
  ultima_visita  DATE          NOT NULL,
  cpf            CHAR(11)      NOT NULL,
  link           VARCHAR(255)  NOT NULL,
  CONSTRAINT visita_pk
    PRIMARY KEY (link, cpf),
  CONSTRAINT visita_cpf_fk
    FOREIGN KEY (cpf)
      REFERENCES Pessoa (cpf),
  CONSTRAINT visita_link_fk
    FOREIGN KEY (link)
      REFERENCES Website (link)
);

CREATE TABLE Contas_Associadas (
  id_contas_associadas  INT           NOT NULL  AUTO_INCREMENT,
  dominio               VARCHAR(89)   NOT NULL,
  link                  VARCHAR(255)  NOT NULL,
  CONSTRAINT contas_associadas_pk
    PRIMARY KEY (id_contas_associadas),
  CONSTRAINT contas_associadas_dominio_fk
    FOREIGN KEY (dominio)
      REFERENCES Email (dominio),
  CONSTRAINT contas_associadas_website_fk
    FOREIGN KEY (link)
      REFERENCES Website (link)
);

CREATE TABLE Credito (
  codigo_banco  INT          NOT NULL,
  limite        INT          NOT NULL,
  valor_pago    INT          NOT NULL,
  cpf           CHAR(11)     NOT NULL,
  tipo          VARCHAR(50)  NOT NULL,
  CONSTRAINT credito_pk
    PRIMARY KEY (cpf, codigo_banco, tipo),
  CONSTRAINT credito_cpf_fk
    FOREIGN KEY (cpf)
      REFERENCES Pessoa (cpf),
  CONSTRAINT credito_banco_fk
    FOREIGN KEY (codigo_banco)
      REFERENCES Banco (codigo_banco)
);

CREATE TABLE Associa (
  conta_associativa  INT  NOT NULL,
  conta_associada    INT  NOT NULL,
  CONSTRAINT associa_pk
    PRIMARY KEY (conta_associativa, conta_associada),
  CONSTRAINT conta_associativa_fk
    FOREIGN KEY (conta_associativa)
      REFERENCES Contas_Associadas (id_contas_associadas),
  CONSTRAINT conta_associada_fk
    FOREIGN KEY (conta_associada)
      REFERENCES Contas_Associadas (id_contas_associadas)
);
