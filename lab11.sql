//1. ������������ ��������� ��������� 
//GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
//��������� ������ �������� ������ �������������� �� ������� TEACHER 
//(� ����������� ��������� �����), ���������� �� �������, �������� ����� � ���������. 
//������������ ��������� ���� � ����������������� ���������� ���������.

create or replace procedure GET_TEACHERS(PCODE TEACHER.PULPIT%TYPE) is
begin
  for i in (select * from TEACHER where PULPIT = PCODE)
    loop
      dbms_output.put_line(i.TEACHER_NAME);
    end loop;
end;

begin
  GET_TEACHERS('����');
end;

//2. ������������ ��������� ������� 
//3. GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE) 
//RETURN NUMBER
//������� ������ �������� ���������� �������������� �� ������� TEACHER, 
//���������� �� �������, �������� ����� � ���������. 
//������������ ��������� ���� � ����������������� ���������� ���������.

create or replace function GET_NUM_TEACHERS(PCODE TEACHER.PULPIT%TYPE) return number is
  tCount number;
begin
  select count(*) into tCount from teacher where pulpit = pcode;
  return tCount;
end;

begin
  dbms_output.put_line('���������� ��������������: ' || GET_NUM_TEACHERS('����'));
end;

//4. ������������ ���������:
//GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
//��������� ������ �������� ������ �������������� �� ������� TEACHER 
//(� ����������� ��������� �����), ���������� �� ����������, �������� ����� � ���������. 
//������������ ��������� ���� � ����������������� ���������� ���������.
//GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
//��������� ������ �������� ������ ��������� �� ������� SUBJECT, 
//������������ �� ��������, �������� ����� ������� � ���������. 
//������������ ��������� ���� � ����������������� ���������� ���������.

create or replace procedure GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE) is
begin
  for i in (select * from TEACHER where PULPIT in (select PULPIT from PULPIT where FACULTY = FCODE))
    loop
      dbms_output.put_line(i.TEACHER_NAME);
    end loop;
end;

begin
  GET_TEACHERS('����');
end;

create or replace procedure GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) is
begin
  for i in (select * from SUBJECT where PULPIT = PCODE)
    loop
      dbms_output.put_line(i.SUBJECT_NAME);
    end loop;
end;

begin
  GET_SUBJECTS('����');
end;

//5. ������������ ��������� ������� 
//GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
//RETURN NUMBER
//������� ������ �������� ���������� �������������� �� ������� TEACHER, 
//���������� �� ����������, �������� ����� � ���������. 
//������������ ��������� ���� � ����������������� ���������� ���������.
//GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) 
//RETURN NUMBER 
//������� ������ �������� ���������� ��������� �� ������� SUBJECT, 
//������������ �� ��������, �������� ����� ������� ���������. 
//������������ ��������� ���� � ����������������� ���������� ���������. 

create or replace function GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) return number
is
  num number;
begin
  select count(*) into num from TEACHER where PULPIT in (select PULPIT from PULPIT where FACULTY = FCODE);
  return num;
end;

begin
  dbms_output.put_line('���������� ��������������: ' || GET_NUM_TEACHERS('����'));
end;

create or replace function GET_NUM_SUBJECT(PCODE SUBJECT.PULPIT%TYPE) return number
is
  num number;
begin
  select count(*) into num from SUBJECT where PULPIT = PCODE;
  return num;
end;

begin
  dbms_output.put_line('���������� ���������: ' || GET_NUM_SUBJECT('����'));
end;

//6. ������������ ����� TEACHERS, ���������� ��������� � �������:
// GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
// GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
// GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER 
// GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER 

create or replace package TEACHERS is
  procedure GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE);
  procedure GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE);
  function GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) return number;
  function GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) return number;
end TEACHERS;

//7. ������������ ��������� ���� � ����������������� 
// ���������� �������� � ������� ������ TEACHERS.
create or replace package body TEACHERS is
  procedure GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE) is
  begin
    for i in (select * from TEACHER where PULPIT in (select PULPIT from PULPIT where FACULTY = FCODE))
      loop
        dbms_output.put_line(i.TEACHER_NAME);
      end loop;
  end;

  procedure GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) is
  begin
    for i in (select * from SUBJECT where PULPIT = PCODE)
      loop
        dbms_output.put_line(i.SUBJECT_NAME);
      end loop;
  end;

  function GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE) return number
    is
    num number;
  begin
    select count(*) into num from TEACHER where PULPIT in (select PULPIT from PULPIT where FACULTY = FCODE);
    return num;
  end;

  function GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) return number
    is
    num number;
  begin
    select count(*) into num from SUBJECT where PULPIT = PCODE;
    return num;
  end;
end TEACHERS;

begin
  TEACHERS.GET_TEACHERS('���');
  TEACHERS.GET_SUBJECTS('����');
  dbms_output.put_line(TEACHERS.GET_NUM_TEACHERS('���'));
  dbms_output.put_line(TEACHERS.GET_NUM_SUBJECTS('����'));
end;