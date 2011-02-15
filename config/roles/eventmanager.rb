name "eventmanager"
description "eventmanager front end application server."
run_list(
  "recipe[mysql::client]",
  "recipe[application]",
  "recipe[monit]"
)
