-- Задание 1. Создайте табличное пространство для постоянных данных со следующими параметрами:
-- - имя: TS_XXX;
-- - имя файла: TS_XXX;
-- - начальный размер: 7М;
-- - автоматическое приращение: 5М;
-- - максимальный размер: 20М.

CREATE TABLESPACE TS_KMO
DATAFILE 'TS_KMO'
SIZE 7M
AUTOEXTEND ON
NEXT 5M
MAXSIZE 20M;

CREATE TEMPORARY TABLESPACE TS_KMO_TEMP
TEMPFILE 'TS_KMO_TEMP'
SIZE 5M
AUTOEXTEND ON
NEXT 3M
MAXSIZE 30M;