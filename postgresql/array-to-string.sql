select item_id, array_to_string(array_agg(origin), ' ')
  from item_origins
 where item_id in ('itm-a558312d48be4e349e90f49c8d7c3337', 'itm-1afd6fd9e8684c338ec3373ba6c64ec5')
 group by item_id;
