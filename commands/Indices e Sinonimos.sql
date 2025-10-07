-- 1. O que é um índice e qual é a sua finalidade?
-- Um índice é uma estrutura auxiliar associada a uma tabela de banco de dados, criada para acelerar o acesso às linhas e otimizar consultas usando as colunas indexadas. Funciona como um “índice remissivo” de um livro: em vez de procurar registro por registro, o índice permite localizar dados rapidamente através de ponteiros, reduzindo o tempo de busca e melhorando o desempenho das consultas.

-- 2. O que é um ROWID e como ele é usado?
-- ROWID é uma pseudo-coluna exclusiva de cada registro em uma tabela Oracle, representando o endereço físico da linha no disco. Ele é prático para identificar de forma única qualquer registro e permite acesso direto e muito rápido à linha. ROWID pode ser usado, por exemplo, para remover registros duplicados da tabela, já que identifica rapidamente exatamente onde cada linha está armazenada.

-- 3. Quando um índice será criado automaticamente?
-- No Oracle, índices são criados automaticamente quando definimos uma chave primária (PRIMARY KEY) ou uma restrição de unicidade (UNIQUE) em uma tabela. Já para chaves estrangeiras (FOREIGN KEYS), o índice não é criado automaticamente — é recomendável criar manualmente nessas colunas se espera realizar pesquisas ou joins frequentes nelas para ganhar performance.

-- 4. Crie um índice não exclusivo (chave estrangeira) para a coluna (cd_number) da DJs on Demand na tabela D_TRACK_LISTINGS. Use o recurso Data Browser do SQL Workshop (Oracle Application Express) para verificar se o índice foi criado.
CREATE INDEX idx_cd_number ON D_TRACK_LISTINGS(cd_number);

-- 5. Use a instrução JOIN para exibir os índices e a exclusividade existentes no dicionário de dados para a tabela D_SONGS da DJs on Demand.
SELECT i.index_name, i.uniqueness
FROM user_indexes i
JOIN user_ind_columns c ON i.index_name = c.index_name
WHERE i.table_name = 'D_SONGS';

-- 6. Use uma instrução SELECT para exibir as informações index_name, table_name e uniqueness existentes no dicionário de dados USER_INDEXES para a tabela D_EVENTS da DJs on Demand.
SELECT index_name, table_name, uniqueness
FROM user_indexes
WHERE table_name = 'D_EVENTS';

-- 7. Escreva uma consulta a fim de criar um sinônimo chamado dj_tracks para a tabela d_track_listings da DJs on Demand.
CREATE SYNONYM dj_tracks FOR d_track_listings;

-- 8. Crie um índice baseado em função para a coluna last_name na tabela D_PARTNERS da DJs on Demand de modo que seja possível realizar pesquisas sem a necessidade de colocar o nome da tabela em maiúsculas. Crie uma instrução SELECT que usaria esse índice.
CREATE INDEX idx_upper_last_name ON D_PARTNERS (UPPER(last_name));
SELECT * FROM D_PARTNERS WHERE UPPER(last_name) = 'SILVA';

-- 9. Crie um sinônimo para a tabela D_TRACK_LISTINGS. Verifique se ele foi criado consultando o dicionário de dados.
CREATE SYNONYM djl_track_syn FOR D_TRACK_LISTINGS;
-- Para verificar:
SELECT synonym_name, table_name
FROM user_synonyms
WHERE synonym_name = 'DJL_TRACK_SYN';

-- 10. Elimine o sinônimo criado na pergunta 9.
DROP SYNONYM djl_track_syn;