-- see https://stackoverflow.com/questions/1461722/how-to-find-child-tables-that-inherit-from-another-table-in-psql
select cn.nspname AS child_schema, c.relname AS child_table
  from pg_inherits
  join pg_class AS c ON (inhrelid=c.oid)
  join pg_class as p ON (inhparent=p.oid)
  join pg_namespace pn ON pn.oid = p.relnamespace
  join pg_namespace cn ON cn.oid = c.relnamespace
 where p.relname = 'users'
   and pn.nspname = 'journal'
 order by 1,2;  
