class CampoDefaultValue < ActiveRecord::Migration
  def self.up
    add_column :campos,  :default_value, :string
    add_column :campos,  :setup_value, :string
  end

  def self.down
    remove_column :campos,  :default_value
    remove_column :campos,  :setup_value    
  end
end
