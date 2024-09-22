-- 1.���������� ����� ������ ������� SGA.
select SUM(VALUE) TOTAL_SGA_IN_BYTES from v$sga;
-- 2.���������� ������� ������� �������� ����� SGA.
select component, current_size from v$sga_dynamic_components where current_size > 0;
-- 3.���������� ������� ������� ��� ������� ����.
select component, granule_size from v$sga_dynamic_components where current_size > 0;
-- 4.���������� ����� ��������� ��������� ������ � SGA.
select CURRENT_SIZE from v$sga_dynamic_free_memory;
-- 5.���������� ������������ � ������� ������ ������� SGA.
select value from v$parameter where name = 'sga_target';
select value from v$parameter where name = 'sga_max_size';
show parameter sga
-- 6.���������� ������� ����� ���P, DEFAULT � RECYCLE ��������� ����.
select COMPONENT, MIN_SIZE, MAX_SIZE, CURRENT_SIZE from v$sga_dynamic_components
where COMPONENT in ('KEEP buffer cache', 'RECYCLE buffer cache', 'DEFAULT buffer cache');
-- 7.�������� �������, ������� ����� ���������� � ��� ���P. ����������������� ������� �������.
create table KEEP_TABLE (num number) storage (buffer_pool keep) tablespace users
;insert into KEEP_TABLE values (1);
insert into KEEP_TABLE values (25);

select * from KEEP_TABLE;
select SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BUFFER_POOL
from user_segments where segment_name like 'KEEP%';
-- 8.�������� �������, ������� ����� ������������ � ���� DEFAULT. ����������������� ������� �������. 
create table DEFAULT_CACHE_TABLE (num number) cache tablespace users;
insert into DEFAULT_CACHE_TABLE values (4);
insert into DEFAULT_CACHE_TABLE values (8);
select * from DEFAULT_CACHE_TABLE;
select SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BUFFER_POOL
from user_segments where segment_name like 'DEFAULT_CACHE%';
-- 9.������� ������ ������ �������� �������.
show parameter log_buffer;
-- 10.������� ������ ��������� ������ � ������� ����.
select pool, name, bytes from v$sgastat where pool='large pool' and name = 'free memory';
-- 11.���������� ������ ������� ���������� � ��������� (dedicated, shared).
select username, service_name, server, osuser, machine, program, STATE
    from v$session
    where username is not null;
-- 12.�������� ������ ������ ���������� � ��������� ����� ������� ���������.
SELECT name, description FROM v$bgprocess;
-- 13.�������� ������ ���������� � ��������� ����� ��������� ���������.
SELECT SPID, PID, PROGRAM FROM V$PROCESS;
select * from v$bgprocess where paddr != '00';
-- 14.����������, ������� ��������� DBWn �������� � ��������� ������.
select count(*) from v$bgprocess where paddr!= '00' and name like 'DBW%';
-- 15.���������� ������� (����� ����������� ����������).
select name, network_name, pdb from v$services;
-- 16.�������� ��������� ��� ��������� �����������.
show parameter dispatchers;
select * from v$dispatcher;
-- 17.������� � ������ Windows-�������� ������, ����������� ������� LISTENER.
select * from v$services;
-- 18.����������������� � �������� ���������� ����� LISTENER.ORA. 
//WINDOWS.x64.../network/admin/listener.ora

-- 19.��������� ������� lsnrctl � �������� �� �������� �������. 
//lsnrctl
/*
        1. start - ��������� ��������� ��� ������ Oracle.
        2. servacls - ���������� ������ �������� � �� ������� ��� ����������� ����� ���������.
        3. trace - �������� ��� ��������� ������� ����������� ��� ���������.
        4. show - ���������� ������� ��������� ��������� ��� ���������� � ������������ ��������.
        5. stop - ������������� ��������� ��� ������ Oracle.
        6. version - ���������� ������ ���������.
        7. quit ��� exit - ������� �� lsnrctl.
        8. status - ���������� ������� ������ ���������.
        9. reload - ������������� ������������ ��������� ��� ��� ���������.
        10. services - ���������� ������ ��������� ��������, ������� ����� ���� �������� ����� ���������.
        11. save_config - ��������� ������� ������������ ��������� � ����.
*/
-- 20.�������� ������ ����� ��������, ������������� ��������� LISTENER. 
//lsnrctl services
























