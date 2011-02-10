class ListavaloresConditionRuntimeVars < ActiveRecord::Migration
  def self.up
    add_column  :lista_valores, :condition_runtime_vars, :string
  end

  def self.down
    remove_column  :lista_valores, :condition_runtime_vars
  end
end
