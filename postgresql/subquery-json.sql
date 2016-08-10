select requests.id,
       row_to_json(responses)::text as response,
       (select to_json(array_agg(row_to_json(responses))) from responses where responses.request_id = requests.id)::text as responses
  from requests
  left join responses on responses.request_id = requests.id
