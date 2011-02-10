class CodigoDescontoCampo < ActiveRecord::Migration
  def self.up
    add_column :campos, :is_codigo_desconto, :boolean
  end

  def self.down
    remove_column :campos, :is_codigo_desconto
  end
end
