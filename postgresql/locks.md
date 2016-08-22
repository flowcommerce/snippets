select 'select pg_cancel_backend(' || pid || ');' from pg_stat_activity ;

select 'select pg_terminate_backend(' || pid || ');' from pg_stat_activity ;

