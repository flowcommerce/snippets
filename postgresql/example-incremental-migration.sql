-- Example script to migrate data incrementally:
--  1% at a time
--  outputs date and time along the way
--  avoids journal records
--
-- run:
-- nohup psql -U api -h <host> -p 5432 -f migration.sql  labeldb > migration.log

-- create table tmp as select id, (random()*100)::smallint as index
--   from labels;
-- create index on tmp(index);


begin;
  alter table labels disable trigger labels_journal_insert_trigger;
  update labels set delivered_duty = null where delivered_duty = 'None' and id in (select tmp.id from tmp where index = 1);
  update labels set delivered_duty = 'paid' where delivered_duty = 'Some(paid)' and id in (select tmp.id from tmp where index = 1);
  update labels set delivered_duty = 'unpaid' where delivered_duty = 'Some(unpaid)' and id in (select tmp.id from tmp where index = 1);
  alter table labels enable trigger labels_journal_insert_trigger;
commit;
