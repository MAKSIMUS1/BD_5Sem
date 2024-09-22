//1-2. �������� ������ �������������� � ���� ������� �.�.
select* from teacher;

select regexp_substr(teacher_name,'(\S+)',1, 1)||' '||
  substr(regexp_substr(teacher_name,'(\S+)',1, 2),1, 1)||'. '||
  substr(regexp_substr(teacher_name,'(\S+)',1, 3),1, 1)||'. ' as ���
from teacher;

//3. �������� ������ ��������������, ���������� � �����������.
select * from teacher where TO_CHAR((birthday),'d') = 1;

//4. �������� �������������, � ������� ��������� ������ ��������������, 
// ������� �������� � ���� ������.
create or replace view zad4 as 
select * 
from teacher
where 
  case
    when to_char(sysdate, 'mm') + 1 = to_char(birthday, 'mm') then 1
    when to_char(sysdate, 'mm') = '12' and to_char(birthday, 'mm') = '01' then 1
    else 0
  end = 1;
  
select * from zad4;

drop view zad4;


//5. �������� �������������, � ������� ��������� ���������� ��������������, 
// ������� �������� � ������ ������.
create or replace view NumberMonths as
  select to_char(birthday, 'Month') �����,
         count(*) ����������
  from teacher
  group by to_char(birthday, 'Month')
  order by ���������� desc;

select * from NumberMonths;
drop view NumberMonths;

//6. ������� ������ � ������� ������ ��������������, � ������� � ��������� ���� ������.
declare
  cursor TeacherBirthday is select * from teacher
       where MOD((TO_CHAR(sysdate,'yyyy') - TO_CHAR(birthday,'yyyy')+1),5)=0;
  
  rec TeacherBirthday%rowtype;
begin
  for rec in TeacherBirthday
    loop
      dbms_output.put_line(TeacherBirthday%rowcount||'. '||rec.teacher_name||' '||rec.pulpit||' '||rec.birthday);
    end loop;
end;

//7. ������� ������ � ������� ������� ���������� ����� �� �������� � ����������� ���� �� �����, 
//������� ������� �������� �������� ��� ������� ���������� � ��� ���� ����������� � �����.


DECLARE
  CURSOR c1 IS
    SELECT DISTINCT
      P.PULPIT,
      F.FACULTY,
      (SELECT FLOOR(AVG(salary)) "������� ��������"
       FROM teacher
       WHERE teacher.pulpit = P.pulpit
       GROUP BY pulpit) AS avg_pulpit_salary,
      (SELECT ROUND(AVG(T1.salary), 3) "������� ��������"
       FROM teacher T1
       WHERE T1.pulpit = P.pulpit) AS avg_faculty_salary,
      (SELECT ROUND(AVG(salary), 3) "������� ��������"
       FROM teacher) AS avg_all_salary
    FROM TEACHER
      JOIN PULPIT P ON P.PULPIT = TEACHER.PULPIT
      JOIN FACULTY F ON F.FACULTY = P.FACULTY;
BEGIN
  FOR i IN c1 LOOP
    DBMS_OUTPUT.PUT_LINE('Faculty: ' || i.FACULTY || ' ~ Pulpit: ' || i.PULPIT || ' ~ Avg pulpit: ' ||
                         i.avg_pulpit_salary || ' ~ Avg faculty: ' || i.avg_faculty_salary ||
                         ' ~ Avg all faculty: ' || i.avg_all_salary);
  END LOOP;
END;


//8. �������� ����������� ��� PL/SQL-������ (record) � ����������������� ������ � ���. 
//����������������� ������ � ���������� ��������. 
//����������������� � ��������� �������� ����������. 
declare 
type ADDRESS is record
        (
          town nvarchar2(20),
          country nvarchar2(20)
        );
type PERSON is record
        (
          name teacher.teacher_name%type,
          pulp teacher.pulpit%type,
          homeAddress ADDRESS
        );
per1 PERSON;
per2 PERSON;
begin
  select teacher_name, pulpit into per1.name, per1.PULP from teacher where teacher='���';
  per1.homeAddress.town := '�����';
  per1.homeAddress.country := '��������';
  per2 := per1;
  dbms_output.put_line( per2.name||' '|| per2.pulp||' �� '|| per2.homeAddress.town||', '|| per2.homeAddress.country);
end;
