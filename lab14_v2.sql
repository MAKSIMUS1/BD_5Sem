alter pluggable database KMO_PDB open;
alter system set JOB_QUEUE_PROCESSES = 200;
alter system set nls_date_format='dd-mm-yyyy hh24:mi:ss';
---------------------------------1
--drop table T1;
--drop table T2;
--drop table job_status;

create table T1
(
    a number,
    b char
);
create table T2
(
    a number,
    b char
);
drop table T2;
drop table T1;

create table job_status
(
    status        nvarchar2(50),
    error_message nvarchar2(500),
    datetime      date default sysdate
);
insert into T1 values (1, 'a');
insert into T1 values (8, 's');
insert into T1 values (9, 'a');
insert into T1 values (41, 'd');
insert into T1 values (3, 'z');
commit;
select * from T1;
select * from T2;

------------------------------------2
--drop procedure job_procedure;
create or replace procedure job_procedure
is
    cursor job_cursor is
    select * from T1;

    err_message varchar2(500);
begin
    for m in job_cursor
    loop
        insert into T2 values (m.a, m.b);
    end loop;

    delete from T1 where a = a;
    insert into job_status (status, datetime) values ('SUCCESS', sysdate);
    commit;
    exception
      when others then
          err_message := sqlerrm;
          insert into job_status (status, error_message) values ('FAILURE', err_message);
          commit;
end job_procedure;

call job_procedure;


declare job_number user_jobs.job%type;
begin
  dbms_job.submit(job_number, 'BEGIN job_procedure(); END;', sysdate, 'sysdate + 7');
  commit;
  dbms_output.put_line(job_number);
end;


select * from JOB_STATUS;

------------------------------------3

select * from user_jobs;

select job, what, last_date, last_sec, next_date, next_sec, broken from user_jobs;

-----------------------------------4

begin
  dbms_job.run(1);
end;

begin
  dbms_job.remove(42);
end;

set serveroutput on;

select * from JOB_STATUS;

------------------------------------6
begin
dbms_scheduler.create_schedule(
  schedule_name => 'SCH',
  start_date => to_timestamp_tz('2023-12-23 10:48:00 Europe/Minsk',
                                'YYYY-MM-DD HH24:MI:SS TZR'),

  repeat_interval => 'FREQ=WEEKLY',
  comments => 'SCH WEEKLY starts now'
);
end;
begin
dbms_scheduler.drop_schedule('SCH');
end;
begin
dbms_scheduler.drop_program('PROGRAM');
end;
begin
dbms_scheduler.drop_job('JOB');
end;

select * from user_scheduler_schedules;

begin
dbms_scheduler.create_program(
  program_name => 'PROGRAM',
  program_type => 'STORED_PROCEDURE',
  program_action => 'job_procedure',
  number_of_arguments => 0,
  enabled => true,
  comments => 'PROGRAM'
);
end;

select * from user_scheduler_programs;


begin
    dbms_scheduler.create_job(
            job_name => 'JOB',
            program_name => 'PROGRAM',
            schedule_name => 'SCH',
            enabled => true
        );
end;

select * from T1;
select * from T2;

select * from user_scheduler_jobs;

begin
  DBMS_SCHEDULER.DISABLE('JOB_1');
end;

begin
    DBMS_SCHEDULER.RUN_JOB('JOB');
end;




begin
  DBMS_SCHEDULER.DROP_JOB( JOB_NAME => 'JOB');
end;


