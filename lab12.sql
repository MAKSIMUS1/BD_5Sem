select OBJECT_NAME, STATUS from USER_OBJECTS where OBJECT_TYPE = 'TRIGGER';

//1
CREATE TABLE PULPIT_LAB12
(
 PULPIT       VARCHAR(30)      NOT NULL,
 PULPIT_NAME  VARCHAR2(200) NOT NULL UNIQUE, 
 FACULTY      VARCHAR(40)      NOT NULL, 
 CONSTRAINT FK_PULPIT_FACULTY_LAB12 FOREIGN KEY(FACULTY)   REFERENCES FACULTY(FACULTY), 
 CONSTRAINT PK_PULPIT_LAB12 PRIMARY KEY(PULPIT) 
 ); 

DROP TABLE PULPIT_LAB12
//2

insert into PULPIT_LAB12   (PULPIT,    PULPIT_NAME,FACULTY )
 values  ('����',    '������������� ������ � ���������� ','���'  );
insert into PULPIT_LAB12   (PULPIT,    PULPIT_NAME,FACULTY )
 values  ('������', '���������������� ��������� ���������� ', '����'  );
insert into PULPIT_LAB12   (PULPIT,    PULPIT_NAME,FACULTY)
  values  ('��',      '�����������', '���') ;
insert into PULPIT_LAB12   (PULPIT,    PULPIT_NAME,FACULTY)
 values  ('��',      '������������', '���') ;   
insert into PULPIT_LAB12   (PULPIT,    PULPIT_NAME,FACULTY)
 values  ('��',      '��������������','���');  
insert into PULPIT_LAB12   (PULPIT,    PULPIT_NAME,FACULTY)
 values  ('�����',   '���������� � ����������������',      '���');    
insert into PULPIT_LAB12   (PULPIT,    PULPIT_NAME,FACULTY)
 values  ('������',  '������������ �������������� � ������-��������� �������������','���');      
insert into PULPIT_LAB12   (PULPIT,    PULPIT_NAME,FACULTY)
 values  ('��',     '���������� ����','����'); 
insert into PULPIT_LAB12   (PULPIT,    PULPIT_NAME,FACULTY)
 values  ('�����',  '������ ����� � ���������� �������������', '����'); 
insert into PULPIT_LAB12   (PULPIT,    PULPIT_NAME,FACULTY)
 values  ('��',     '������������ �����',      '���');
insert into PULPIT_LAB12   (PULPIT,    PULPIT_NAME,  FACULTY)
 values  ('��������','���������� ���������������� ������� � ����������� ���������� ����������','���'); 
 
 
select * from PULPIT_LAB12;
 
insert into PULPIT_LAB12   (PULPIT,    PULPIT_NAME,   FACULTY)
 values  ('�������','���������� �������������� ������� � ����� ���������� ���������� ','����');        
insert into PULPIT_LAB12    (PULPIT,    PULPIT_NAME, FACULTY)
 values  ('��������','�����, ���������� ����������������� ����������� � ���������� ����������� �������', '����');
insert into PULPIT   (PULPIT,    PULPIT_NAME,   FACULTY)
 values  ('����',    '������������� ������ � ����������',     '���');   
insert into PULPIT   (PULPIT,    PULPIT_NAME,   FACULTY)
 values  ('����',   '����������� � ��������� ������������������', '���');


//3
grant create trigger to NRV;

create or replace trigger PULPIT_TRIGGER_OPERATORS_BEFORE
  before insert or delete or update
  on PULPIT_LAB12
begin
  dbms_output.put_line('PULPIT_TRIGGER_OPERATORS_BEFORE');
end;

//4
//5

create or replace trigger PULPIT_TRIGGER_ROW_BEFORE
  before insert or delete or update
  on PULPIT_LAB12
  for each row
begin
  dbms_output.put_line('PULPIT_TRIGGER_ROW_BEFORE');
end;

update PULPIT_LAB12
set PULPIT_NAME = PULPIT_NAME
where 0 = 0;

//6
create or replace trigger PULPIT_TRIGGER_ROW_BEFORE
  before insert or delete or update
  on PULPIT_LAB12
  for each row
begin
  if inserting then
    dbms_output.put_line('PULPIT_TRIGGER ROW INSERTING BEFORE');
  elsif updating then
    dbms_output.put_line('PULPIT_TRIGGER ROW UPDATING BEFORE');
  elsif deleting then
    dbms_output.put_line('PULPIT_TRIGGER ROW DELETING BEFORE');
  end if;
end;

//7
create or replace trigger PULPIT_TRIGGER_OPERATORS_AFTER
  after insert or delete or update
  on PULPIT_LAB12
begin
  dbms_output.put_line('PULPIT_TRIGGER OPERATORS AFTER');
end;

update PULPIT_LAB12
set PULPIT_NAME = PULPIT_NAME
where 0 = 0;

//8
create or replace trigger PULPIT_TRIGGER_ROW_AFTER
  after insert or delete or update
  on PULPIT_LAB12
  for each row
begin
  dbms_output.put_line('PULPIT_TRIGGER ROW AFTER');
end;

//9
create table AUDIT_LOG
(
  OperationDate date,
  OperationType varchar(100),
  TriggerName   varchar(100)
);

//10
create or replace trigger PULPIT_TRIGGER_OPERATORS_BEFORE
  before insert or delete or update
  on PULPIT_LAB12
begin
  insert into AUDIT_LOG values (sysdate, 'PULPIT_TRIGGER OPERATORS BEFORE', 'PULPIT_TRIGGER_OPERATORS_BEFORE');
end;

create or replace trigger PULPIT_TRIGGER_ROW_BEFORE
  before insert or delete or update
  on PULPIT_LAB12
  for each row
begin
  insert into AUDIT_LOG values (sysdate, 'PULPIT_TRIGGER ROW BEFORE', 'PULPIT_TRIGGER_ROW_BEFORE');
end;

create or replace trigger PULPIT_TRIGGER_OPERATORS_AFTER
  after insert or delete or update
  on PULPIT_LAB12
begin
  insert into AUDIT_LOG values (sysdate, 'PULPIT_TRIGGER OPERATORS AFTER', 'PULPIT_TRIGGER_OPERATORS_AFTER');
end;

create or replace trigger PULPIT_TRIGGER_ROW_AFTER
  after insert or delete or update
  on PULPIT_LAB12
  for each row
begin
  insert into AUDIT_LOG values (sysdate, 'PULPIT_TRIGGER ROW AFTER', 'PULPIT_TRIGGER_ROW_AFTER');
end;

update PULPIT_LAB12
set PULPIT_NAME = PULPIT_NAME
where 0 = 0;
select * from AUDIT_LOG;
truncate table AUDIT_LOG;

//11

insert into PULPIT_LAB12   (PULPIT,    PULPIT_NAME,  FACULTY)
 values  ('�����SDFSDF','A','���'); 

select * from USER_TRIGGERS;
select * from AUDIT_LOG;

//12

drop table PULPIT_LAB12;

flashback table PULPIT_LAB12 to before drop;

create or replace trigger BEFORE_DROP
  before drop on NRV.SCHEMA
begin
  if ORA_DICT_OBJ_NAME <> 'PULPIT_LAB12' then
    return;
  end if;

  raise_application_error(-20001, '������ ������� ������� PULPIT_LAB12');
end;


//13
drop table AUDIT_LOG;
select TRIGGER_NAME, STATUS from USER_TRIGGERS;

//14
create view PULPIT_VIEW as
    select * from PULPIT;

create or replace trigger PULPIT_VIEW_TRIGGER
  instead of insert on PULPIT_VIEW
begin
  insert into AUDIT_LOG values (sysdate, 'STUDENT_VIEW_TRIGGER', 'STUDENT_VIEW_TRIGGER');
  insert into PULPIT_LAB12 values (:new.PULPIT, :new.PULPIT_NAME, :new.FACULTY);
end;

//15
delete from PULPIT_LAB12 where PULPIT = '�����SDFSDF';
truncate table AUDIT_LOG;

insert into PULPIT_VIEW
values  ('�����SDFSDF','A','���'); 
select * from  PULPIT_VIEW;

select * from AUDIT_LOG;
select * from PULPIT_LAB12;






