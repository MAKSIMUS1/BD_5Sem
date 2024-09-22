-- 1. �������� ������ ���� ������������ PDB � ������ ���������� ORA12W. 
-- ���������� �� ������� ���������.
select name,open_mode from v$pdbs; 

-- 2. ��������� ������ � ORA12W, ����������� �������� �������� �����������.
select INSTANCE_NAME from v$instance;

-- 3. ��������� ������ � ORA12W, ����������� �������� �������� 
-- ������������� ����������� ���� Oracle 12c � �� ������ � ������. 
select * from PRODUCT_COMPONENT_VERSION;

-- 4. �������� ����������� ��������� PDB 
-- (���������� ������������ � ������� � ���������� ���������� � ����������� Database Configuration Assistant)
-- � ������ XXX_PDB, ��� XXX � �������� ��������
-- ~ � DCA

-- 5. �������� ������ ���� ������������ PDB � ������ ���������� ORA12W. 
-- ���������, ��� ��������� PDB-���� ������ ����������.
select name,open_mode from v$pdbs;

-- 6. ������������ � XXX_PDB c ������� SQL Developer 
-- �������� ���������������� ������� 
-- (��������� ������������, ����, ������� ������������, ������������ � ������ U1_XXX_PDB).

CREATE TABLESPACE TS_KMO_PDB
DATAFILE 'TS_KMO_PDB'
SIZE 7M
AUTOEXTEND ON
NEXT 5M
MAXSIZE 20M;

CREATE TEMPORARY TABLESPACE TS_KMO_TEMP_PDB
TEMPFILE 'TS_KMO_TEMP_PDB'
SIZE 5M
AUTOEXTEND ON
NEXT 3M
MAXSIZE 30M;

CREATE ROLE RL_KMOCORE_PDB;
GRANT
    CONNECT,
    CREATE TABLE,
    CREATE VIEW,
    CREATE PROCEDURE,
    DROP ANY TABLE,
    DROP ANY VIEW,
    DROP ANY PROCEDURE
TO RL_KMOCORE_PDB;

CREATE PROFILE PF_KMOCORE_PDB LIMIT
    FAILED_LOGIN_ATTEMPTS 7
    SESSIONS_PER_USER 3
    PASSWORD_LIFE_TIME 60
    PASSWORD_REUSE_TIME 365
    PASSWORD_LOCK_TIME 1
    CONNECT_TIME 180
    IDLE_TIME 30;

CREATE USER U1_KMO_PDB IDENTIFIED BY 1234
    DEFAULT TABLESPACE TS_KMO_PDB
    TEMPORARY TABLESPACE TS_KMO_TEMP_PDB
    PROFILE PF_KMOCORE_PDB
    ACCOUNT UNLOCK;

GRANT CREATE SESSION, SYSDBA TO U1_KMO_PDB;
GRANT CREATE TABLE, CREATE VIEW, DROP ANY TABLE, DROP ANY VIEW TO U1_KMO_PDB;

-- 7. ������������ � ������������ U1_XXX_PDB, � ������� SQL Developer, 
-- �������� ������� XXX_table, �������� � ��� ������, ��������� SELECT-������ � �������.
CREATE TABLE KMO_T1
(
    ID NUMBER,
    NAME VARCHAR2(10)
);

INSERT INTO KMO_T1 VALUES (1, 'A');
INSERT INTO KMO_T1 VALUES (2, 'B');
INSERT INTO KMO_T1 VALUES (3, 'C');

SELECT * FROM KMO_T1;

DROP TABLE KMO_T1;

-- 8. � ������� ������������� ������� ���� ������ ����������, ��� ��������� ������������, 
-- ���  ����� (������������ � ���������), ��� ���� (� �������� �� ����������), 
-- ������� ������������, ���� �������������  ���� ������ XXX_PDB �  ����������� �� ����.
select * from DBA_USERS; 
select * from DBA_TABLESPACES; 
select * from DBA_DATA_FILES;   
select * from DBA_TEMP_FILES;  
select * from DBA_ROLES;
select * from DBA_ROLE_PRIVS; 
select * from DBA_PROFILES;

-- 9.

CREATE USER C##KMO IDENTIFIED BY 1234
GRANT CREATE SESSION, SYSDBA TO C##KMO

select * from DBA_USERS;
-- 13.
alter pluggable database KMO_PDB close;
drop pluggable database KMO_PDB including datafiles;

-- ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;
-- alter pluggable database KMO_PDB OPEN;
-- drop user C##KMO cascade

