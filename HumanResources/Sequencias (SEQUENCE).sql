-- 1. Criar tabela seq_d_songs copiando d_songs
CREATE TABLE SEQ_D_SONGS AS SELECT * FROM D_SONGS;

-- 2. Criar sequência personalizada para a tabela seq_d_songs
CREATE SEQUENCE SEQ_D_SONGS_SEQ
    START WITH 100
    INCREMENT BY 2
    MAXVALUE 1000
    NOCACHE
    NOCYCLE;

-- 3. Consultar as configurações da sequência
SELECT * FROM USER_SEQUENCES
WHERE SEQUENCE_NAME = 'SEQ_D_SONGS_SEQ';

-- 4. Inserir duas músicas usando a sequência
INSERT INTO SEQ_D_SONGS (ID, TITLE, DURATION, ARTIST, TYPE_CODE)
VALUES (SEQ_D_SONGS_SEQ.NEXTVAL, 'Island Fever', '5 min', 'Hawaiian Islanders', 12);

INSERT INTO SEQ_D_SONGS (ID, TITLE, DURATION, ARTIST, TYPE_CODE)
VALUES (SEQ_D_SONGS_SEQ.NEXTVAL, 'Castle of Dreams', '4 min', 'The Wanderers', 77)

-- 5. Exibir valor atual da sequência
SELECT SEQ_D_SONGS_SEQ.CURRVAL FROM DUAL;

-- 6. Três vantagens de usar sequências
-- Garantem geração automática de valores únicos.
-- Evitam conflitos de chaves primárias em tabelas grandes.
-- Não dependem de tabelas específicas, podendo ser reutilizadas em múltiplas tabelas.

-- 7. Vantagens de armazenar valores de sequência em cache
-- Melhora performance ao reduzir acesso ao disco.
-- Permite alocação rápida de múltiplos valores.
-- Diminui o tempo de espera em operações massivas de inserção.

-- 8. Três motivos para haver intervalos (gaps) numa sequência
-- Rollback de transação após consultar NEXTVAL.
-- Sequência utilizada em transações paralelas (concorrência).
-- Sistema ou sessão cai após alocar valores em cache (com CACHE ligado).

-- Exercício de Extensão
-- 1. Criar tabela students
CREATE TABLE STUDENTS(
    STUDENT_ID NUMBER(6) PRIMARY KEY,
    NAME VARCHAR(50),
    COURSE VARCHAR(30),
    REGISTRATION_DATE DATE
);

-- 2. Criar sequência student_id_seq
CREATE SEQUENCE STUDENT_ID_SEQ
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- 3. Inserir alunos usando a sequência
INSERT INTO STUDENTS (STUDENT_ID, NAME, COURSE, REGISTRATION_DATE)
VALUES (STUDENT_ID_SEQ.NEXTVAL, 'Maria Silva', 'Computer Science', SYSDATE);

INSERT INTO STUDENTS (STUDENT_ID, NAME, COURSE, REGISTRATION_DATE)
VALUES (STUDENT_ID_SEQ.NEXTVAL, 'João Souza', 'Information Systems', SYSDATE);