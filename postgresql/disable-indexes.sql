-- See https://fle.github.io/temporarily-disable-all-indexes-of-a-postgresql-table.html
-- 1. Disable all table indexes

UPDATE pg_index
SET indisready=false
WHERE indrelid in (
    SELECT oid
    FROM pg_class
    WHERE relname='<TABLE_NAME>'
);

-- 2. Do you operationsRun your query


-- 3. Reenable all table indexes
UPDATE pg_index
SET indisready=true
WHERE indrelid in (
    SELECT oid
    FROM pg_class
    WHERE relname='<TABLE_NAME>'
);

-- 4. Reindex table
REINDEX table <TABLE_NAME>;
