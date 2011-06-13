name "eventmanager_load_balancer"
description "eventmanager load balancer"
run_list(
  "recipe[haproxy::app_lb]"
)
override_attributes(
  "haproxy" => {
    "app_server_role" => "eventmanager"
  }
)
