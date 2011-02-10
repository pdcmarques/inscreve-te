class CampoLongDescription < ActiveRecord::Migration
  def self.up
    add_column :campos, :long_description, :text
  end

  def self.down
    remove_column :campos, :long_description
  end
end
