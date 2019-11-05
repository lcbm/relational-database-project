USE comportamento_digital;

-- 1 - Uso de BETWEEN
SELECT cpf, valor_pago, limite
  FROM Credito
 WHERE valor_pago BETWEEN (limite / 2) AND limite;

SELECT cpf, valor_pago, limite
  FROM Credito
 WHERE valor_pago NOT BETWEEN (limite / 2) AND limite;

-- 2 Uso de LIKE/NOT LIKE com tokens (% ou _)
SELECT id_contas_associadas, dominio
  FROM Contas_Associadas
 WHERE dominio LIKE '%@gmail.com';

SELECT id_contas_associadas, dominio
  FROM Contas_Associadas
 WHERE dominio NOT LIKE '%@gmail.com';

-- 3 Uso de IN com subconsulta
SELECT Pessoa.nome, Pessoa.cpf
  FROM Pessoa
 WHERE Pessoa.cpf NOT IN
  (SELECT Visita.cpf
     FROM Visita
    WHERE Visita.cpf = Pessoa.cpf AND Visita.link LIKE '%.org/');

SELECT nome, cpf, sexo
  FROM Pessoa
 WHERE Pessoa.cpf NOT IN
  (SELECT Visita.cpf
     FROM Visita
    WHERE Visita.cpf = Pessoa.cpf AND Visita.link LIKE '%.org/');

-- 4 Uso de IS NULL/IS NOT NULL
SELECT cpf, nome
  FROM Pessoa
 WHERE cpf IS NOT NULL;

SELECT cpf, nome
  FROM Pessoa
 WHERE cpf IS NULL;

-- 5 Uso de ORDER BY
SELECT cpf, valor_pago, limite
  FROM Credito
 ORDER BY valor_pago ASC;

SELECT cpf, valor_pago, limite
  FROM Credito
 ORDER BY limite DESC;

-- 6 - Usar ALTER TABLE para Modificação de Coluna (roda a 7a primeiro, pls (: )
 ALTER TABLE Pessoa
MODIFY idade VARCHAR(3);

-- 7 - Usar ALTER TABLE para Adicionar Coluna
ALTER TABLE Pessoa
  ADD idade INT(3) NOT NULL
AFTER data_nascimento;

-- 8 - Usar ALTER TABLE para Remover de Coluna
ALTER TABLE Pessoa
 DROP idade;

-- 9 - Operadores aritméticos (+, -, *, /, %, DIV, unary minus) no SELECT
SELECT *
  FROM
    (SELECT cpf, data_nascimento, FLOOR(DATEDIFF(CURDATE(), data_nascimento) / 365) AS idade
       FROM Pessoa) as pessoa
 WHERE pessoa.idade BETWEEN 18 AND 65;

-- 10 - Função de agregação (Sum(), Min(), Max(), Count(), Avg()) com ​GROUP BY
SELECT
  SUM(valor_pago) AS soma_valor_pago,
  SUM(limite) AS soma_limite,
  MIN(valor_pago) AS min_valor_pago,
  MIN(limite) AS min_limite,
  MAX(valor_pago) AS max_valor_pago,
  MAX(limite) AS max_limite,
  AVG(valor_pago) AS avg_valor_pago,
  AVG(limite) AS avg_limite,
  COUNT(*) AS num_credito_concedido
 FROM Credito
GROUP BY tipo;

-- 10 - Função de agregação (Sum(), Min(), Max(), Count(), Avg()) com ​GROUP BY
-- 12 - Uso de HAVING
-- 14 - Junção usando INNER JOIN
SELECT Banco.codigo_banco
  FROM (Agencia INNER JOIN Banco ON Agencia.codigo_banco = Banco.codigo_banco)
 GROUP BY Agencia.codigo_banco
HAVING Agencia.codigo_banco
  BETWEEN (MAX(Agencia.codigo_agencia) / 2) AND MAX(Agencia.codigo_agencia);

-- 11 - Uso de DISTINCT
SELECT COUNT(DISTINCT cpf)
  FROM Visita;

-- 13 - Junção entre duas tabelas
SELECT Pessoa.cpf, Pessoa.nome, Credito.limite, Credito.valor_pago
  FROM Pessoa JOIN Credito
    ON Pessoa.cpf = Credito.cpf;

-- 14 - Junção usando INNER JOIN
SELECT Credito.cpf, Credito.limite, Credito.codigo_banco, Banco.cnpj
  FROM Credito INNER JOIN Banco
    ON Credito.codigo_banco = Banco.codigo_banco;

-- 15 - Junção usando LEFT OUTER JOIN
SELECT Endereco_Pessoa.cpf, Endereco_Pessoa.cep, Endereco_Agencia.codigo_agencia, Endereco_Agencia.cep
  FROM Endereco_Pessoa LEFT OUTER JOIN Endereco_Agencia
    ON Endereco_Pessoa.cep = Endereco_Agencia.cep
 GROUP BY Endereco_Pessoa.cep;

-- 16 - Junção usando RIGHT OUTER JOIN
SELECT Pessoa.cpf, Visita.link, Visita.ultima_visita
  FROM Pessoa RIGHT OUTER JOIN Visita
    ON Visita.ultima_visita BETWEEN '1997-05-07' AND '2017-05-07'
 GROUP BY Visita.ultima_visita;

-- 17 - Junção usando FULL OUTER JOIN
SELECT Pessoa.cpf, Visita.cpf, Visita.link, Visita.ultima_visita
  FROM Pessoa LEFT OUTER JOIN Visita
    ON Visita.ultima_visita BETWEEN '1997-10-07' AND '2007-12-31'
 UNION ALL
SELECT Pessoa.cpf, Visita.cpf, Visita.link, Visita.ultima_visita
  FROM Visita LEFT OUTER JOIN Pessoa
    ON Visita.ultima_visita BETWEEN '1997-10-07' AND '2007-12-31'
 GROUP BY Visita.link;

-- 18 - Uma subconsulta com ​uso de ANY ou SOME
SELECT cliente.cep, cliente.codigo_banco, cliente.codigo_agencia
 FROM Endereco_Agencia as cliente
WHERE cliente.cep = ANY
  (SELECT concorrente.cep
     FROM Endereco_Agencia as concorrente
    WHERE cliente.cep = concorrente.cep);

-- 19 - Uma subconsulta com ​uso de EXISTS/NOT EXISTS
SELECT Pessoa.cpf, Telefone.telefone, Email.dominio
  FROM Pessoa, Telefone, Email
 WHERE EXISTS
      (SELECT limite
         FROM Credito
        WHERE cpf = Pessoa.cpf AND cpf = Telefone.cpf AND cpf = Email.cpf AND limite < 1100);

-- 20 - Uma subconsulta com ​uso de ALIAS ​com consultas aninhadas (ALIAS​ externo sendo 21 - referenciado na subconsulta)
-- É o que mais tem no código x.x

-- 22 - Bloco anônimo
BEGIN NOT ATOMIC
  UPDATE Pessoa SET Pessoa.idade =
    (SELECT FLOOR(DATEDIFF(CURDATE(), data_nascimento) / 365) AS idade
       FROM Pessoa
       WHERE Pessoa.cpf = '11109727574')
   WHERE Pessoa.cpf = '11109727574';
END

-- 23 - Uso de IF ­THEN ­ELSE
SELECT
  CASE
    WHEN FLOOR(DATEDIFF(CURDATE(), data_nascimento) / 365) < 18
    THEN 'Menor de idade'
    WHEN FLOOR(DATEDIFF(CURDATE(), data_nascimento) / 365) BETWEEN 18 AND 25
    THEN 'Jovem'
    ELSE 'Idoso'
  END AS faixa_etaria, cpf, data_nascimento, FLOOR(DATEDIFF(CURDATE(), data_nascimento) / 365) as idade
FROM Pessoa;

-- 24 - Criação de VIEW
CREATE VIEW View_website_info AS
SELECT Website.link AS link, Categoria.nome
  FROM Categoria, Website

-- 25 - Consulta sobre VIEW
SELECT *
  FROM View_website_info
 WHERE link='http://ankunding.com/'

-- 26 - Criação e uso de PROCEDURE
DELIMITER //
CREATE PROCEDURE pessoas_por_cep(IN cep CHAR(8))
BEGIN
  SELECT *
    FROM Pessoa, Endereco_Pessoa
   WHERE Endereco_Pessoa.cep = @cep AND Pessoa.cpf = Endereco_Pessoa.cpf;
END;
//
DELIMITER ;

SET @cep = '00419-85';
CALL pessoas_por_cep(@resultado);
DROP PROCEDURE pessoas_por_cep;

-- 27 - Criação e uso de FUNCTION
DELIMITER //
CREATE FUNCTION pessoa_de_interesse(limite INT, valor_pago INT) RETURNS CHAR(1)
BEGIN
  DECLARE is_pessoa_de_interesse CHAR(1);
  IF (limite - valor_pago) > 400 THEN
    SET is_pessoa_de_interesse = 'T';
  ELSE
    SET is_pessoa_de_interesse ='F';
  END IF;
  RETURN (is_pessoa_de_interesse);
END;
//
DELIMITER ;

SET @limite = 401;
SET @valor_pago = 4;
SELECT pessoa_de_interesse(@limite, @valor_pago);

-- TODO!
-- 28 - Criação e uso de TRIGGER
