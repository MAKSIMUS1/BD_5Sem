-- 1.Определите общий размер области SGA.
select SUM(VALUE) TOTAL_SGA_IN_BYTES from v$sga;
-- 2.Определите текущие размеры основных пулов SGA.
select component, current_size from v$sga_dynamic_components where current_size > 0;
-- 3.Определите размеры гранулы для каждого пула.
select component, granule_size from v$sga_dynamic_components where current_size > 0;
-- 4.Определите объем доступной свободной памяти в SGA.
select CURRENT_SIZE from v$sga_dynamic_free_memory;
-- 5.Определите максимальный и целевой размер области SGA.
select value from v$parameter where name = 'sga_target';
select value from v$parameter where name = 'sga_max_size';
show parameter sga
-- 6.Определите размеры пулов КЕЕP, DEFAULT и RECYCLE буферного кэша.
select COMPONENT, MIN_SIZE, MAX_SIZE, CURRENT_SIZE from v$sga_dynamic_components
where COMPONENT in ('KEEP buffer cache', 'RECYCLE buffer cache', 'DEFAULT buffer cache');
-- 7.Создайте таблицу, которая будет помещаться в пул КЕЕP. Продемонстрируйте сегмент таблицы.
create table KEEP_TABLE (num number) storage (buffer_pool keep) tablespace users
;insert into KEEP_TABLE values (1);
insert into KEEP_TABLE values (25);

select * from KEEP_TABLE;
select SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BUFFER_POOL
from user_segments where segment_name like 'KEEP%';
-- 8.Создайте таблицу, которая будет кэшироваться в пуле DEFAULT. Продемонстрируйте сегмент таблицы. 
create table DEFAULT_CACHE_TABLE (num number) cache tablespace users;
insert into DEFAULT_CACHE_TABLE values (4);
insert into DEFAULT_CACHE_TABLE values (8);
select * from DEFAULT_CACHE_TABLE;
select SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BUFFER_POOL
from user_segments where segment_name like 'DEFAULT_CACHE%';
-- 9.Найдите размер буфера журналов повтора.
show parameter log_buffer;
-- 10.Найдите размер свободной памяти в большом пуле.
select pool, name, bytes from v$sgastat where pool='large pool' and name = 'free memory';
-- 11.Определите режимы текущих соединений с инстансом (dedicated, shared).
select username, service_name, server, osuser, machine, program, STATE
    from v$session
    where username is not null;
-- 12.Получите полный список работающих в настоящее время фоновых процессов.
SELECT name, description FROM v$bgprocess;
-- 13.Получите список работающих в настоящее время серверных процессов.
SELECT SPID, PID, PROGRAM FROM V$PROCESS;
select * from v$bgprocess where paddr != '00';
-- 14.Определите, сколько процессов DBWn работает в настоящий момент.
select count(*) from v$bgprocess where paddr!= '00' and name like 'DBW%';
-- 15.Определите сервисы (точки подключения экземпляра).
select name, network_name, pdb from v$services;
-- 16.Получите известные вам параметры диспетчеров.
show parameter dispatchers;
select * from v$dispatcher;
-- 17.Укажите в списке Windows-сервисов сервис, реализующий процесс LISTENER.
select * from v$services;
-- 18.Продемонстрируйте и поясните содержимое файла LISTENER.ORA. 
//WINDOWS.x64.../network/admin/listener.ora

-- 19.Запустите утилиту lsnrctl и поясните ее основные команды. 
//lsnrctl
/*
        1. start - Запускает слушатель баз данных Oracle.
        2. servacls - Отображает список сервисов и их доступа для подключений через слушателя.
        3. trace - Включает или отключает функцию трассировки для слушателя.
        4. show - Отображает текущие настройки слушателя или информацию о подключенных клиентах.
        5. stop - Останавливает слушатель баз данных Oracle.
        6. version - Отображает версию слушателя.
        7. quit или exit - Выходит из lsnrctl.
        8. status - Отображает текущий статус слушателя.
        9. reload - Перезагружает конфигурацию слушателя без его остановки.
        10. services - Отображает список доступных сервисов, которые могут быть запущены через слушателя.
        11. save_config - Сохраняет текущую конфигурацию слушателя в файл.
*/
-- 20.Получите список служб инстанса, обслуживаемых процессом LISTENER. 
//lsnrctl services
























