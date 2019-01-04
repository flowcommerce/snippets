select kc.column_name
  from information_schema.table_constraints tc
  join information_schema.key_column_usage kc on
       kc.table_name = tc.table_name
       and kc.table_schema = tc.table_schema
       and kc.constraint_name = tc.constraint_name
 where tc.constraint_type = trim('PRIMARY KEY')
   and tc.table_schema = trim('public')
   and tc.table_name = trim('inspector_table_1')
 order by kc.ordinal_position;
