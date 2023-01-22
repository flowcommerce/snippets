select distinct z.to_table_schema, z.to_table_name
    from (
      select c.constraint_name, c.unique_constraint_name,
          x.table_schema as from_table_schema, x.table_name as from_table_name, x.column_name as from_column_name,
          y.constraint_schema as to_table_schema, y.table_name as to_table_name, y.column_name as to_column_name
      from information_schema.referential_constraints c
      join information_schema.key_column_usage x on x.constraint_name = c.constraint_name
      join (
            select kc.constraint_schema, kc.constraint_name, kc.table_name, kc.column_name
              from information_schema.table_constraints tc
              join information_schema.key_column_usage kc
                on kc.table_name = tc.table_name
                and kc.table_schema = tc.table_schema
                and kc.constraint_name = tc.constraint_name
      ) y on y.constraint_schema = c.unique_constraint_schema and y.constraint_name = c.unique_constraint_name
      order by c.constraint_name, x.ordinal_position
    ) z
  where z.from_table_schema = 'plaid'
    and z.from_table_name = 'access_tokens';
