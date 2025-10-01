-- 1. Criar tabela seq_d_songs copiando d_songs
create table seq_d_songs as select * from d_songs;

-- 2. Criar sequência personalizada para a tabela seq_d_songs
create sequence seq_d_songs_seq
    start with 100
    increment by 2
    maxvalue 1000
    nocache 
    nocycle;

-- 3. Consultar as configurações da sequência
select * from user_sequences
where sequence_name = 'seq_d_songs_seq';

-- 4. Inserir duas músicas usando a sequência
insert into seq_d_songs (id, title, duration, artist, type_code)
values (seq_d_songs_seq.nextval, 'Island Fever', '5 min', 'Hawaiian Islanders', 12);

insert into seq_d_songs (id, title, duration, artist, type_code)
values (seq_d_songs_seq.nextval, 'Castle of Dreams', '4 min', 'The Wanderers', 77);

-- 5. Exibir valor atual da sequência
select seq_d_songs_seq.currval from dual;

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
create table students(
    student_id number(6) primary key,
    name varchar(50),
    course varchar(30),
    registration_date date
);

-- 2. Criar sequência student_id_seq
create sequence student_id_seq
    start with 1
    increment by 1
    nocache
    nocycle;

-- 3. Inserir alunos usando a sequência
insert into students (student_id, name, course, registration_date)
values (student_id_seq.nextval, 'Maria Silva', 'Computer Science', sysdate);

insert into students (student_id, name, course, registration_date)
values (student_id_seq.NEXTVAL, 'João Souza', 'Information Systems', sysdate);
