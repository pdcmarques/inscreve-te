class ValidacaoCampos < ActiveRecord::Migration
  def self.up
    add_column :campos, :required, :boolean
    add_column :campos, :min_value, :decimal
    add_column :campos, :max_value, :decimal
    add_column :campos, :regexp, :string
  end

  def self.down
    remove_column :campos, :required
    remove_column :campos, :min_value
    remove_column :campos, :max_value
    remove_column :campos, :regexp
  end
end
