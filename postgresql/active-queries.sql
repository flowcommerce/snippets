select current_timestamp-query_start as runtime,
 datname,usename, query FROM pg_stat_activity
 where state='active'
 order by 1 desc
 limit 100;
