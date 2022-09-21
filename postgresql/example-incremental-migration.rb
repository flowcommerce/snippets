#!/usr/bin/env ruby

# create table tmp as
#  select id, ('{"key": "' || (experience->>'key') || '", "discriminator": "experience_reference"}')::json  as correct_experience,
#         (random()*500)::smallint as index
#   from erm_experience.orders
#   where experience::text not like '%discrim%';

# create index on tmp(index, id);
# create index on tmp(index, correct_experience);

0.upto(500) do |i|
  puts "begin;"
  puts "select #{i} as index, now();"

  puts "alter table erm_experience.orders disable trigger user;"
  puts "UPDATE erm_experience.orders o SET experience = tmp.correct_experience FROM tmp WHERE tmp.id = o.id AND tmp.index = #{i};"
  puts "alter table erm_experience.orders enable trigger user;"
  puts "commit;"
end
