name "eventmanager_run_migrations"
description "Run db:migrate on demand for eventmanager"
override_attributes( "apps" => { "eventmanager" => { "production" => { "run_migrations" => true } } })
