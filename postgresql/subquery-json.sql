select
  id,
  description,
  (
   select array_agg(categories.label)
    from allocations
    join categories on categories.id = allocations.category_id
   where allocations.transaction_id = transactions.id
  ) as allocations
from transactions;
