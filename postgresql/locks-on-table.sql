-- from https://stackoverflow.com/questions/37110149/postgresql-find-locks-including-the-table-name
select t.relname,l.locktype,page,virtualtransaction,pid,mode,granted
  from pg_locks l, pg_stat_all_tables t
 where l.relation=t.relid
   and relname='tmp_cards'
 order by relation asc;

-- SELECT pg_cancel_backend(pid);
