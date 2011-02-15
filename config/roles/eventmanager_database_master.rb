name "eventmanager_database_master"
description "Database master for the eventmanager application."
run_list(
  "recipe[eventmanager::master]"
)
