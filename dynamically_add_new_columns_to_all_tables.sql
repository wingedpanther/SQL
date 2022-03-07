DO $$ DECLARE
 alter_query record; 
 BEGIN FOR selectrow in
	SELECT 
	 'ALTER TABLE '|| t.mytable || ' ADD COLUMN foo integer NULL' AS script
	FROM 
	 (
	SELECT tablename AS mytable
	FROM pg_tables
	WHERE schemaname ='public' --schema name 
	) t
LOOP 
EXECUTE alter_query.script; 
END LOOP; 
END;
$$;

-- to verify
SELECT 
 table_name,COLUMN_NAME
FROM 
 INFORMATION_SCHEMA.COLUMNS
WHERE 
 COLUMN_NAME='foo' -- table name