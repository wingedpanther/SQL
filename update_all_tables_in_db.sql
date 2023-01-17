-- Postgres

do $$
  declare
    arow record;
  begin
    for arow in
    select 
        'update '||c.table_name||' set '||c.COLUMN_NAME||' = ''your_value'';' 
         as my_update_query
     from 
        (select 
            table_name,COLUMN_NAME
         from INFORMATION_SCHEMA.COLUMNS 
         where table_name LIKE 'agg%' and COLUMN_NAME LIKE '%userid%') c
    loop
     execute arow.my_update_query;
    end loop;
  end;
$$;

