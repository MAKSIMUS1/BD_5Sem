-- ������� 1. �������� ��������� ������������ ��� ���������� ������ �� ���������� �����������:
-- - ���: TS_XXX;
-- - ��� �����: TS_XXX;
-- - ��������� ������: 7�;
-- - �������������� ����������: 5�;
-- - ������������ ������: 20�.

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