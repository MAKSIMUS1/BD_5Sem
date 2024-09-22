SELECT * FROM dba_tablespaces;
SELECT * FROM dba_data_files;

-- Задание 4. Создайте роль с именем RL_XXXCORE. Назначьте ей следующие системные привилегии:
-- 	разрешение на соединение с сервером;
-- 	разрешение создавать и удалять таблицы, представления, процедуры и функции.

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE ROLE RL_KMOCORE;
GRANT
    CONNECT,
    CREATE TABLE,
    CREATE VIEW,
    CREATE PROCEDURE,
    DROP ANY TABLE,
    DROP ANY VIEW,
    DROP ANY PROCEDURE
TO RL_KMOCORE;

-- Задание 5. Найдите с помощью select-запроса роль в словаре.
-- Найдите с помощью select-запроса все системные привилегии, назначенные роли.

SELECT * FROM DBA_ROLES WHERE ROLE = 'RL_KMOCORE';
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RL_KMOCORE';

-- Задание 6. Создайте профиль безопасности с именем PF_XXXCORE, имеющий опции, аналогичные примеру из лекции.

CREATE PROFILE PF_KMOCORE LIMIT
    FAILED_LOGIN_ATTEMPTS 7 -- количество попыток входа в систему
    SESSIONS_PER_USER 3 -- количество сессий на пользователя
    PASSWORD_LIFE_TIME 60 -- время жизни пароля
    PASSWORD_REUSE_TIME 365 -- время до повторного использования пароля
    PASSWORD_LOCK_TIME 1 -- время блокировки пароля
    CONNECT_TIME 180 -- время подключения
    IDLE_TIME 30; -- время простоя


-- Задание 7. Получите список всех профилей БД. Получите значения всех параметров профиля PF_XXXCORE.
-- Получите значения всех параметров профиля DEFAULT.

SELECT * FROM DBA_PROFILES;
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'PF_KMOCORE';
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'DEFAULT';

-- Задание 8. Создайте пользователя с именем XXXCORE со следующими параметрами:
-- - табличное пространство по умолчанию: TS_XXX;
-- - табличное пространство для временных данных: TS_XXX_TEMP;
-- - профиль безопасности PF_XXXCORE;
-- - учетная запись разблокирована;
-- - срок действия пароля истек

CREATE USER KMOCORE IDENTIFIED BY 123456
    DEFAULT TABLESPACE TS_KMO
    TEMPORARY TABLESPACE TS_KMO_TEMP
    PROFILE PF_KMOCORE
    ACCOUNT UNLOCK
    PASSWORD EXPIRE;
t
GRANT CREATE SESSION TO KMOCORE;
GRANT CREATE TABLE, CREATE VIEW, DROP ANY TABLE, DROP ANY VIEW TO KMOCORE;


DROP USER KMOCORE;



-- Задание 10. Создайте соединение с помощью SQL Developer для пользователя XXXCORE.
-- Создайте любую таблицу и любое представление.








-- !!! ПОМЕНЯТЬ

CREATE TABLE ANYTABLE
(
  ID NUMBER
);

CREATE VIEW ANYVIEW AS SELECT * FROM ANYTABLE;

DROP TABLE ANYTABLE;
DROP VIEW ANYVIEW;

-- Задание 11. Создайте табличное пространство с именем XXX_QDATA (10m).
-- При создании установите его в состояние offline.
-- Затем переведите табличное пространство в состояние online.
-- Выделите пользователю XXX квоту 2m в пространстве XXX_QDATA.
-- От имени пользователя XXX создайте таблицу в пространстве XXX_T1. В таблицу добавьте 3 строки.

CREATE TABLESPACE KMO_QDATA
    DATAFILE 'KMO_QDATA.DBF'
    SIZE 10M
    OFFLINE;

SELECT TABLESPACE_NAME, STATUS, CONTENTS FROM DBA_TABLESPACES;

ALTER TABLESPACE KMO_QDATA ONLINE;

ALTER USER KMOCORE QUOTA 2M ON KMO_QDATA;

DROP TABLESPACE KMO_QDATA INCLUDING CONTENTS;

-- переключи сессию и роль на GDVCORE!

CREATE TABLE KMO_T1
(
    ID NUMBER,
    NAME VARCHAR2(10)
) TABLESPACE KMO_QDATA;

INSERT INTO KMO_T1 VALUES (1, 'A');
INSERT INTO KMO_T1 VALUES (2, 'B');
INSERT INTO KMO_T1 VALUES (3, 'C');

SELECT * FROM KMO_T1;

DROP TABLE KMO_T1;

