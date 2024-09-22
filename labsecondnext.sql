SELECT * FROM dba_tablespaces;
SELECT * FROM dba_data_files;

-- ������� 4. �������� ���� � ������ RL_XXXCORE. ��������� �� ��������� ��������� ����������:
-- 	���������� �� ���������� � ��������;
-- 	���������� ��������� � ������� �������, �������������, ��������� � �������.

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

-- ������� 5. ������� � ������� select-������� ���� � �������.
-- ������� � ������� select-������� ��� ��������� ����������, ����������� ����.

SELECT * FROM DBA_ROLES WHERE ROLE = 'RL_KMOCORE';
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'RL_KMOCORE';

-- ������� 6. �������� ������� ������������ � ������ PF_XXXCORE, ������� �����, ����������� ������� �� ������.

CREATE PROFILE PF_KMOCORE LIMIT
    FAILED_LOGIN_ATTEMPTS 7 -- ���������� ������� ����� � �������
    SESSIONS_PER_USER 3 -- ���������� ������ �� ������������
    PASSWORD_LIFE_TIME 60 -- ����� ����� ������
    PASSWORD_REUSE_TIME 365 -- ����� �� ���������� ������������� ������
    PASSWORD_LOCK_TIME 1 -- ����� ���������� ������
    CONNECT_TIME 180 -- ����� �����������
    IDLE_TIME 30; -- ����� �������


-- ������� 7. �������� ������ ���� �������� ��. �������� �������� ���� ���������� ������� PF_XXXCORE.
-- �������� �������� ���� ���������� ������� DEFAULT.

SELECT * FROM DBA_PROFILES;
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'PF_KMOCORE';
SELECT * FROM DBA_PROFILES WHERE PROFILE = 'DEFAULT';

-- ������� 8. �������� ������������ � ������ XXXCORE �� ���������� �����������:
-- - ��������� ������������ �� ���������: TS_XXX;
-- - ��������� ������������ ��� ��������� ������: TS_XXX_TEMP;
-- - ������� ������������ PF_XXXCORE;
-- - ������� ������ ��������������;
-- - ���� �������� ������ �����

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



-- ������� 10. �������� ���������� � ������� SQL Developer ��� ������������ XXXCORE.
-- �������� ����� ������� � ����� �������������.








-- !!! ��������

CREATE TABLE ANYTABLE
(
  ID NUMBER
);

CREATE VIEW ANYVIEW AS SELECT * FROM ANYTABLE;

DROP TABLE ANYTABLE;
DROP VIEW ANYVIEW;

-- ������� 11. �������� ��������� ������������ � ������ XXX_QDATA (10m).
-- ��� �������� ���������� ��� � ��������� offline.
-- ����� ���������� ��������� ������������ � ��������� online.
-- �������� ������������ XXX ����� 2m � ������������ XXX_QDATA.
-- �� ����� ������������ XXX �������� ������� � ������������ XXX_T1. � ������� �������� 3 ������.

CREATE TABLESPACE KMO_QDATA
    DATAFILE 'KMO_QDATA.DBF'
    SIZE 10M
    OFFLINE;

SELECT TABLESPACE_NAME, STATUS, CONTENTS FROM DBA_TABLESPACES;

ALTER TABLESPACE KMO_QDATA ONLINE;

ALTER USER KMOCORE QUOTA 2M ON KMO_QDATA;

DROP TABLESPACE KMO_QDATA INCLUDING CONTENTS;

-- ��������� ������ � ���� �� GDVCORE!

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

