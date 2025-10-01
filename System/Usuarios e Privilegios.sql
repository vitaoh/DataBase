-- 17-1 --
-- 1. Para que servem os privilégios de sistema?
-- Os privilegios de sistema servem para autorizar um usuario a fazer certas operacoes no banco de dados como um todo nao apenas em objetos especificos.

-- 2. Para que servem os privilégios de objeto?
-- Os privilegios de objetos serverm para um usuario executar operacoes em objetos do banco de dados como tabelas, views entre outros.

-- 3. Qual é o outro nome dado à segurança de objetos?
-- Segurança discricionária.

-- 4. Quais comandos são necessários para permitir o acesso de Scott ao banco de dados com a senha tiger?
CREATE USER scott IDENTIFIED BY tiger;
GRANT CONNECT TO scott;

-- 5. Quais são os comandos usados para permitir que Scott faça uma seleção na tabela d-clients e atualize essa tabela?
GRANT SELECT, UPDATE ON d_clientes TO scott;

-- 6. Qual é o comando usado para permitir que todos exibam a tabela d_songs?
GRANT SELECT ON d_songs TO PUBLIC;

-- 7. Consulte o dicionário de dados para exibir os privilégios de objeto concedidos a você, o usuário.
SELECT * FROM user_tab_privs;

-- 8. Qual privilégio deve ser concedido a um usuário para que ele crie tabelas?
GRANT CREATE TABLE TO user_name;

-- 9. Se você criar uma tabela, como poderá transferir privilégios para que outros usuários apenas exibam a sua tabela?
GRANT SELECT ON table_name TO user_name;

-- 10.Qual sintaxe você usaria para conceder a outro usuário acesso à sua tabela copy_employees?
GRANT SELECT ON copy_employees TO user_name;

-- 11.Como você pode saber quais privilégios foram concedidos para as colunas das tabelas pertencentes a outros usuários?
SELECT * FROM dba_col_privs WHERE OWNER = 'user_name';

--- / - / ---

-- 17-2 --
--  1. O que é uma atribuição?
-- Uma atribuicao (role) e um conjunto de privilegios agrupados logicamente que pode ser concedido ou revogado de usuarios de forma simplificada.

--  2. Quais são as vantagens de uma atribuição para um DBA?
-- E a facilitacao do gerenciamente de privilegios concedidos ou revogados, pois podem conceder varios privilegios de uma vez so minimizando erros e desorganizacoes.

-- 3. Permita que outro usuário de sua turma examine uma de suas tabelas. Conceda a ele o direito de permitir que outros alunos possam fazer isso.
GRANT SELECT ON table_name TO user_name WITH GRANT OPTION;

-- 4. Você é o DBA e está criando vários usuários que precisam dos mesmos privilégios de sistema. O que você deve usar para facilitar o seu trabalho?
CREATE ROLE role_name;
GRANT privileges TO role_name;
GRANT role_name TO user_name;

-- 5. Qual é a sintaxe usada para realizar os procedimentos a seguir?
    -- a. Criar uma atribuição de gerente com privilégios para selecionar, inserir, atualizar e excluir informações da tabela employees
    CREATE ROLE gerente;
    GRANT SELECT, INSERT, UPDATE, DELETE ON employees TO gerente;

    -- b. Criar uma atribuição de funcionário com privilégios apenas para selecionar e inserir informações na tabela employees
    CREATE ROLE funcionario;
    GRANT SELECT, INSERT ON employees TO funcionario;
    
    -- c. Conceder a atribuição de gerente ao usuário scott
    GRANT gerente TO scott;

    -- d. Revogar da atribuição de gerente a capacidade de excluir informações da tabela employees
    REVOKE DELETE ON employees FROM gerente;

-- 6. Qual é a finalidade de um link de banco de dados?
-- Um link de banco de dados permite acessar objetos de outros bancos remotamente, facilitando consultas e manipulação de dados distribuídos sem necessidade de duplicação.