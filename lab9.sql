//1. ������������ ��, ��������������� ������ ��������� SELECT � ������ ��������.
declare
  fac faculty%rowtype;
begin
  select * into fac from faculty where faculty='���';
  dbms_output.put_line(fac.faculty||' '|| fac.faculty_name);
end;

//2. ������������ ��, ��������������� ������ ��������� SELECT � �������� ������ ��������. 
// ����������� ����������� WHEN OTHERS ������ ���������� 
// � ���������� ������� SQLERRM, SQLCODE ��� ���������������� �������� �������
declare
  fac faculty%rowtype;
begin
  select * into fac from faculty where faculty='���';
  dbms_output.put_line(fac.faculty||' '|| fac.faculty_name);
exception
  when others
    then dbms_output.put_line(sqlerrm);
end;

//3. ������������ ��, ��������������� ������ ����������� 
// WHEN TO_MANY_ROWS ������ ���������� ��� ���������������� �������� �������. 
declare
  fac faculty%rowtype;
begin
  select * into fac from faculty;
  dbms_output.put_line(fac.faculty||' '|| fac.faculty_name);
exception
  when too_many_rows
    then dbms_output.put_line('� ���������� ��������� �����');
  when others
    then dbms_output.put_line(sqlerrm);
end;

//4. ������������ ��, ��������������� ������������� � ��������� ���������� NO_DATA_FOUND. 
// ������������ ��, ��������������� ���������� ��������� �������� �������.
declare
  fac faculty%rowtype;
begin
  select * into fac from faculty where faculty='���';
  dbms_output.put_line(fac.faculty||' '|| fac.faculty_name);
exception
  when no_data_found
    then dbms_output.put_line('������ �� �������');
  when others
    then dbms_output.put_line(sqlerrm);
end;
-- ~~~~~~~~~~~~~~~~~~~
declare
    b1 boolean;
    b2 boolean;
    b3 boolean;
    n pls_integer;
  fac faculty%rowtype;
begin
  select * into fac from faculty where faculty='���';
  b1 := sql%found;
  b2 := sql%isopen;
  b3 := sql%notfound;
  n := sql%rowcount;
  dbms_output.put_line(fac.faculty||' '|| fac.faculty_name);
  if b1 then dbms_output.put_line('b1 = TRUE');
  else       dbms_output.put_line('b1 = FALSE');
  end if;
  if b2 then dbms_output.put_line('b2 = TRUE');
  else       dbms_output.put_line('b2 = FALSE');
  end if;
  if b3 then dbms_output.put_line('b3 = TRUE');
  else       dbms_output.put_line('b3 = FALSE');
  end if;
  dbms_output.put_line('n = ' || n);
end;

//5. ������������ ��, ��������������� ���������� ��������� UPDATE ��������� � ����������� COMMIT/ROLLBACK. 
//6. ����������������� �������� UPDATE, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
select * from auditorium order by auditorium;
begin
  update AUDITORIUM set auditorium='428-4'
    where auditorium='429-4';
  --commit;    
  rollback;
  dbms_output.put_line('[OK] Successfully updated.');
  exception when others then
    dbms_output.put_line('[ERROR] ' || sqlerrm);
end;

//7. ������������ ��, ��������������� ���������� ��������� INSERT ��������� � ����������� COMMIT/ROLLBACK.
//8. ����������������� �������� INSERT, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
select * from auditorium order by auditorium;
begin
  insert into auditorium(auditorium, auditorium_name, auditorium_capacity, auditorium_type)
  values('485-5', '485-5', 80, '��-�');
  --commit;    
  rollback;
  dbms_output.put_line('[OK] Successfully inserted.');
  exception when others then
    dbms_output.put_line('[ERROR] ' || sqlerrm);
end;

//9. ������������ ��, ��������������� ���������� ��������� DELETE ��������� � ����������� COMMIT/ROLLBACK.
//10. ����������������� �������� DELETE, ���������� ��������� ����������� � ���� ������. ����������� ��������� ����������.
select * from AUDITORIUM order by AUDITORIUM;
begin
  delete from auditorium where auditorium = '475-5';
  if(sql%rowcount= 0) then
    raise no_data_found;
  end if;
  --commit;
  rollback;
  dbms_output.put_line('[OK] Successfully deleted.');
  exception when others then
    dbms_output.put_line('[ERROR] ' || sqlerrm);
end;

//11. �������� ��������� ����, ��������������� ������� TEACHER � ����������� ������ ������� LOOP-�����. 
// ��������� ������ ������ ���� �������� � ����������, ����������� � ����������� ����� %TYPE.
declare
  cursor curs is select teacher_name,pulpit from teacher;
   m_name      teacher.teacher_name%type;
   m_pulpit    teacher.pulpit%type;
begin
  open curs;
    dbms_output.put_line('rowcount = '||curs%rowcount);
    loop
      fetch curs into m_name,m_pulpit;
      exit when curs%notfound;
      dbms_output.put_line(curs%rowcount||'. '||m_name||' '||m_pulpit);
    end loop;
    dbms_output.put_line('rowcount = '||curs%rowcount);
  close curs;
  exception
    when others then dbms_output.put_line(sqlerrm);
end;

//12. �������� ��, ��������������� ������� SUBJECT � ����������� ������ ������� � WHILE-�����. 
// ��������� ������ ������ ���� �������� � ������ (RECORD), ����������� � ����������� ����� %ROWTYPE.
declare
  cursor curs is select subject,subject_name, pulpit from SUBJECT;
  rec subject%rowtype;
begin
  open curs;
  dbms_output.put_line('rowcount = '|| curs%rowcount);
  fetch curs into rec;
  while curs%found
    loop
      dbms_output.put_line(curs%rowcount||'. '||rec.subject||' '||rec.subject_name||' '||rec.pulpit);
      fetch curs into rec;
    end loop;
    dbms_output.put_line('rowcount = ' || curs%rowcount);
  close curs;
end;

// 13. �������� ��, ��������������� ��� ������� (������� PULPIT) � ������� ���� �������������� (TEACHER) �����������, 
// ���������� (JOIN) PULPIT � TEACHER � � ����������� ������ ������� � FOR-�����.
declare
  cursor curs is select pulpit.pulpit, teacher.teacher_name
  from pulpit inner join teacher on pulpit.pulpit=teacher.pulpit;
  rec curs%rowtype;
begin
  for rec in curs
    loop
      dbms_output.put_line(curs%rowcount||'. '||rec.teacher_name||' '||rec.pulpit);
    end loop;
end;

//14. �������� ��, ��������������� ��������� ������ ���������: ��� ��������� (������� AUDITORIUM) 
// � ������������ ������ 20, �� 21-30, �� 31-60, �� 61 �� 80, �� 81 � ����. 
// ��������� ������ � ����������� � ��� ������� ����������� ����� �� ������� �������.
declare 
  cursor curs(cap1 auditorium.auditorium%type,cap2 auditorium.auditorium%type)
    is select auditorium, auditorium_capacity from auditorium where 
    auditorium_capacity >= cap1 and auditorium_capacity <= cap2;
    rec curs%rowtype;
begin
    dbms_output.put_line('����������� <20: ');
    for aud in curs(0,20)
      loop dbms_output.put(aud.auditorium||',');
      end loop;
    dbms_output.put_line(chr(10)||'����������� 20-30: ');
    open curs(21,30);
        fetch curs into rec;
        loop
            dbms_output.put(rec.auditorium||' ');
            fetch curs into rec;
            exit when curs%notfound;
        end loop;
    close curs;      
    dbms_output.put_line(chr(10)||'����������� 30-60: ');
    open curs(31,60);
        fetch curs into rec;
        while curs%found
            loop
            dbms_output.put(rec.auditorium||' ');
            fetch curs into rec;
        end loop;
    close curs;   
    dbms_output.put_line(chr(10)||'����������� 60-80: ');
    for aud in curs(61,80)
      loop dbms_output.put(aud.auditorium||' '); end loop;  
    dbms_output.put_line(chr(10)||'����������� ���� 80: ');
    for aud in curs(81,1000)
      loop dbms_output.put(aud.auditorium||' '); end loop;  
end;  

//15. �������� A�. �������� ��������� ���������� � ������� ���������� ���� ref cursor. 
// ����������������� �� ���������� ��� ������� c �����������. 
declare
  type auditorium_ref is ref cursor return auditorium%rowtype;
  xcurs auditorium_ref;
  xcurs_row xcurs%rowtype;
begin
  open xcurs for select * from auditorium;
  fetch xcurs into xcurs_row;
  loop
    exit when xcurs%notfound;
    dbms_output.put_line(' '||xcurs_row.auditorium||' '||xcurs_row.auditorium_capacity);
    fetch xcurs into xcurs_row;
  end loop;
  close xcurs;
  
  exception when others then
    dbms_output.put_line(sqlerrm);
end;

//16. �������� A�. ����������������� ��������� ���������.
declare
  cursor curs_aud is select auditorium_type,
      cursor (select auditorium from auditorium aum
              where aut.auditorium_type = aum.auditorium_type)
              from auditorium_type aut;
  curs_aum sys_refcursor;
  aut auditorium_type.auditorium_type%type;
  aum auditorium.auditorium%type;
begin
  open curs_aud;
  fetch curs_aud into aut, curs_aum;
  while (curs_aud%found)
    loop
    dbms_output.put_line(''||curs_aud%rowcount||'. '||aut);
      loop
        fetch curs_aum into aum;
        exit when curs_aum%notfound;
        dbms_output.put_line('  '||curs_aum%rowcount||'. '||aum);
      end loop;
      dbms_output.new_line;
      fetch curs_aud into aut,curs_aum;     
    end loop;
  close curs_aud;
end;
 
//17. �������� A�. ��������� ����������� ���� ��������� (������� AUDITORIUM) ������������ �� 40 �� 80 �� 10%. 
// ����������� ����� ������ � �����������, ���� FOR, ����������� UPDATE CURRENT OF
select * from auditorium order by auditorium;
declare
  cursor curs_auditorium(cap1 auditorium.auditorium%type, cap2 auditorium.auditorium%type)
  is 
    select auditorium, auditorium_capacity 
    from auditorium
    where auditorium_capacity >=cap1 
    and AUDITORIUM_CAPACITY <= cap2
    for update;
  aum auditorium.auditorium%type;
  cty auditorium.auditorium_capacity%type;
begin
  open curs_auditorium(40,80);
  fetch curs_auditorium into aum, cty;
  
  while(curs_auditorium%found)
  loop
    cty := cty * 0.9;
      update auditorium 
      set auditorium_capacity = cty 
      where current of curs_auditorium;
    dbms_output.put_line(' '||aum||' '||cty);
    fetch curs_auditorium into aum, cty;
  end loop;
  
  close curs_auditorium;
  rollback;
  exception when others then
   dbms_output.put_line(sqlerrm);
end;

//18. �������� A�. ������� ��� ��������� (������� AUDITORIUM) ������������ �� 0 �� 20. 
// ����������� ����� ������ � �����������, ���� WHILE, ����������� UPDATE CURRENT OF. 
declare 
  cursor cur(cap1 auditorium.auditorium%type,cap2 auditorium.auditorium%type)
    is select auditorium,auditorium_capacity from auditorium
    where auditorium_capacity between cap1 and cap2 for update;
  aum auditorium.auditorium%type;
  cap auditorium.auditorium_capacity%type;
begin

  dbms_output.put_line('�� ��������: ');
  for pp in cur(0,120) 
    loop
      dbms_output.put_line(cur%rowcount|| '. ' || pp.auditorium||' '||pp.auditorium_capacity);
    end loop;
  open cur(0,20);
  fetch cur into aum,cap;
  
  while(cur%found)
    loop
      delete auditorium where current of cur;
      fetch cur into aum,cap;
    end loop;
  close cur;
  dbms_output.put_line('����� ��������: ');
  
  for pp in cur(0,120) 
    loop
      dbms_output.put_line(cur%rowcount|| '. ' || pp.auditorium||' '||pp.auditorium_capacity);
    end loop;
    
  rollback;
end;

//19. �������� A�. ����������������� ���������� ������������� ROWID � ���������� UPDATE � DELETE. 
declare
  cursor cur(capacity auditorium.auditorium%type)
    is select auditorium, auditorium_capacity, rowid
    from auditorium where auditorium_capacity >=capacity for update;
  aum auditorium.auditorium%type;
  cap auditorium.auditorium_capacity%type;
begin
  for xxx in cur(80)
   loop
    if xxx.auditorium_capacity >=80 then 
      update auditorium
      set auditorium_capacity = auditorium_capacity+3 where rowid = xxx.rowid;
    end if;
   end loop;
  for yyy in cur(80)
   loop
    dbms_output.put_line(yyy.auditorium||' '||yyy.auditorium_capacity);
   end loop; 
   rollback;
end;
select * from auditorium;

//20. ������������ � ����� ����� ���� �������������� (TEACHER), �������� �������� �� ��� (�������� ������ ������ -------------). 
declare
  cursor cur_teacher is select teacher,teacher_name,pulpit from teacher;
  m_teacher teacher.teacher%type;
  m_teacher_name teacher.teacher_name%type;
  m_pulpit teacher.pulpit%type;
  i integer:=1;
begin
  open cur_teacher;
  loop
    fetch cur_teacher into m_teacher,m_teacher_name,m_pulpit;
    exit when cur_teacher%notfound;
    dbms_output.put_line(cur_teacher%rowcount||'. ' ||m_teacher||' '
                          ||m_teacher_name||' '
                          ||m_pulpit);
    if(i mod 3 = 0) then 
      dbms_output.put_line('-------------------------------------------'); 
    end if;
    i:= i + 1;
  end loop;
  dbms_output.put_line('rowcount = ' || cur_teacher%rowcount);
  close cur_teacher;
  exception
    when others then dbms_output.put_line(sqlerrm);
end;