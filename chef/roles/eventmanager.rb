name "eventmanager"
description "eventmanager front end application server."
run_list(
  "recipe[subversion]",
  "recipe[application]",
  "recipe[mysql::client]"
)
