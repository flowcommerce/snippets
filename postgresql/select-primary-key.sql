explain  select columns.column_name, columns.column_default, columns.is_nullable, columns.data_type
   from information_schema.table_constraints tc                                                         
   join information_schema.constraint_column_usage AS ccu USING (constraint_schema, constraint_name)                              
   join information_schema.columns ON columns.table_schema = tc.constraint_schema AND tc.table_name = columns.table_name AND ccu.column_name = columns.column_name
  where constraint_type = trim('PRIMARY KEY')
    and tc.table_schema = trim('erm_experience')
    and tc.table_name = trim('orders');
