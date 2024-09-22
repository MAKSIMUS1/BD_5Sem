//1
//C:\Users\maksim\Desktop\WINDOWS.X64_193000_db_home\network\admin

//2
//show parameter instance

//3
//alter pluggable database kmo_pdb open;
select * from dba_tablespaces;
select * from dba_data_files;
select * from dba_roles;
select * from dba_users;

//4
//Редактор реестра

//5
//6
create user U1_lab6 identified by 1234;
grant create session to U1_lab6;
alter user U1_lab6 default tablespace users;
alter user U1_lab6 quota unlimited on users;
grant restricted session to U1_lab6;
grant create table to U1_lab6;
grant insert any table to U1_lab6;
grant select any table to U1_lab6;

drop user U1_lab6
create table U1_lab6_table
(
name varchar(20)
);
insert into U1_lab6_table values ('aaa');
drop table U1_lab6_table;
commit;
select * from userlab6_table;

//7-9

//10
select segment_name, segment_type from dba_segments where owner = 'SYSTEM';

//11

create or replace VIEW all_segments AS
    select
        owner, SEGMENT_TYPE,
        count(*) as segments_count,
        sum(extents) as total_extents,
        sum(blocks) as total_blocks,
        sum(bytes)/1024 as total_bytes
    from dba_segments
    group by owner, SEGMENT_TYPE;

select * from all_segments;
