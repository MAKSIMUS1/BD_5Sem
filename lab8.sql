alter pluggable database KMO_PDB open;

//1.	������������ ���������� ��������� ���� PL/SQL (��), �� ���������� ����������
BEGIN
  NULL;
END;

//2.	������������ ��, ��������� �Hello World!�. ��������� ��� � SQLDev � SQL+.
BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello World!');
END;

//3.	����������������� ������ ���������� � ���������� ������� sqlerrm, sqlcode
DECLARE
  v_num NUMBER;
BEGIN
  v_num := 1/0;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
end;


//4.	������������ ��������� ����. ����������������� ������� ��������� ���������� �� ��������� ������.
DECLARE
  v_num NUMBER;
BEGIN
  declare
  begin
    v_num := 1/0;
  exception
    when others then
      dbms_output.put_line('Error: ' || sqlerrm);
      dbms_output.put_line('Error code: ' || sqlcode);
  end;
  dbms_output.put_line('Hello World!');
end;

//5.	��������, ����� ���� �������������� ����������� �������������� � ������ ������.
select type, value from v_$parameter
    where name = 'plsql_warnings';
    
//6.	������������ ������, ����������� ����������� ��� ����������� PL/SQL.
select keyword from V_$RESERVED_WORDS
    where LENGTH = 1 and KEYWORD <> 'A';

//7.	������������ ������, ����������� ����������� ��� �������� �����  PL/SQL.
select keyword from V_$RESERVED_WORDS
    where LENGTH > 1 and keyword <> 'A'  order by keyword;

//8.	������������ ������, ����������� ����������� ��� ��������� Oracle Server, ��������� � PL/SQL. 
// ����������� ��� �� ��������� � ������� SQL+-������� show.
select name, value from v_$parameter
    where name like 'plsql%';
    
//----------------------------------------- 
//9.	������������ ��������� ����, ��������������� (��������� � �������� ��������� ����� ����������):
//10.	���������� � ������������� ����� number-����������;
DECLARE
  v_num1 NUMBER := 1;
  v_num2 INTEGER := 2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1);
  DBMS_OUTPUT.PUT_LINE(v_num2);
END;

//11.	�������������� �������� ��� ����� ������ number-����������, ������� ������� � ��������;
DECLARE
  v_num1 NUMBER := 1;
  v_num2 NUMBER(3) := 2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1 + v_num2);
  DBMS_OUTPUT.PUT_LINE(v_num1 - v_num2);
  DBMS_OUTPUT.PUT_LINE(v_num1 * v_num2);
  DBMS_OUTPUT.PUT_LINE(v_num1 / v_num2);
  DBMS_OUTPUT.PUT_LINE(v_num1 mod v_num2);
END;

//12.	���������� � ������������� number-���������� � ������������� ������;
DECLARE
  v_num1 NUMBER := 1.1;
  v_num2 NUMBER(3, 1) := 2.2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1);
  DBMS_OUTPUT.PUT_LINE(v_num2);
END;

//13.	���������� � ������������� number-���������� � ������������� ������ � ������������� ��������� (����������);
DECLARE
  v_num1 NUMBER := 1.1;
  v_num2 NUMBER(3, -1) := 2.2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1);
  DBMS_OUTPUT.PUT_LINE(v_num2);
END;

//14.	���������� � ������������� BINARY_FLOAT-����������;
DECLARE
  v_num BINARY_FLOAT := 1.1;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num);
end;

//15.	���������� � ������������� BINARY_DOUBLE-����������;
DECLARE
  v_num BINARY_DOUBLE := 1.1;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num);
END;

//16.	���������� number-���������� � ������ � ����������� ������� E (������� 10) ��� �������������/����������;
DECLARE
  v_num1 NUMBER := 1.1E1;
  v_num2 NUMBER := 1.1E-1;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1);
  DBMS_OUTPUT.PUT_LINE(v_num2);
END;

//17.	���������� � ������������� BOOLEAN-����������. 
DECLARE
  v_bool BOOLEAN := TRUE;
BEGIN
  IF v_bool THEN
    DBMS_OUTPUT.PUT_LINE('TRUE');
  ELSE
    DBMS_OUTPUT.PUT_LINE('FALSE');
  END IF;
END;
//----------------------------------------- 

//18.	������������ ��������� ���� PL/SQL ���������� ���������� �������� (VARCHAR2, CHAR, NUMBER). 
DECLARE
  VCHAR_CONST CONSTANT VARCHAR2(20) := 'VCHAR_CONST';
  CHAR_CONST CONSTANT CHAR(20) := 'CHAR_CONST';
  NUMBER_CONST CONSTANT NUMBER := 1;
BEGIN
  DBMS_OUTPUT.PUT_LINE(VCHAR_CONST);
  DBMS_OUTPUT.PUT_LINE(CHAR_CONST);
  DBMS_OUTPUT.PUT_LINE(NUMBER_CONST);
END;

//19.	������������ ��, ���������� ���������� � ������ %TYPE.
DECLARE
  VCHAR_CONST CONSTANT VARCHAR2(20) := 'VCHAR_CONST';
  CHAR_CONST CONSTANT CHAR(20 char) := 'CHAR_CONST';
  NUMBER_CONST CONSTANT NUMBER := 1;
  VCHAR_CONST2 VCHAR_CONST%TYPE := 'VCHAR_CONST2';
  CHAR_CONST2 CHAR_CONST%TYPE := 'CHAR_CONST2';
  NUMBER_CONST2 NUMBER_CONST%TYPE := 2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(VCHAR_CONST2);
  DBMS_OUTPUT.PUT_LINE(CHAR_CONST2);
  DBMS_OUTPUT.PUT_LINE(NUMBER_CONST2);
END;

//20.	������������ ��, ���������� ���������� � ������ %ROWTYPE.
DECLARE
  AUDITORIUM_TYPE_ROW AUDITORIUM_TYPE%ROWTYPE;
BEGIN
  AUDITORIUM_TYPE_ROW.AUDITORIUM_TYPE := 'Auditorium';
  AUDITORIUM_TYPE_ROW.AUDITORIUM_TYPENAME := '���������';

  DBMS_OUTPUT.PUT_LINE(AUDITORIUM_TYPE_ROW.AUDITORIUM_TYPE);
  DBMS_OUTPUT.PUT_LINE(AUDITORIUM_TYPE_ROW.AUDITORIUM_TYPENAME);
end;

//21 22 IF
DECLARE
  v_num NUMBER := 1;
BEGIN
  IF v_num = 1 THEN
    DBMS_OUTPUT.PUT_LINE('v_num = 1');
  ELSIF v_num = 2 THEN
    DBMS_OUTPUT.PUT_LINE('v_num = 2');
  ELSIF v_num is null THEN
    DBMS_OUTPUT.PUT_LINE('v_num is null');
  ELSE
    DBMS_OUTPUT.PUT_LINE('v_num = 3');
  END IF;
END;



//23 CASE
DECLARE
  v_num NUMBER := 1;
BEGIN
  CASE v_num
    WHEN 1 THEN
      DBMS_OUTPUT.PUT_LINE('v_num = 1');
    WHEN 2 THEN
      DBMS_OUTPUT.PUT_LINE('v_num = 2');
    WHEN 3 THEN
      DBMS_OUTPUT.PUT_LINE('v_num = 3');
    ELSE
      DBMS_OUTPUT.PUT_LINE('v_num is null');
  END CASE;
END;

//24 LOOP

DECLARE
  v_num NUMBER := 1;
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE(v_num);
    v_num := v_num + 1;
    EXIT WHEN v_num > 10;
  END LOOP;
END;

//25 WHILE
DECLARE
  v_num NUMBER := 1;
BEGIN
  WHILE v_num <= 10 LOOP
    DBMS_OUTPUT.PUT_LINE(v_num);
    v_num := v_num + 1;
  END LOOP;
END;

//26 FOR
DECLARE
  v_num NUMBER := 1;
BEGIN
  FOR i IN 1..10 LOOP
    DBMS_OUTPUT.PUT_LINE(i);
  END LOOP;
END;



