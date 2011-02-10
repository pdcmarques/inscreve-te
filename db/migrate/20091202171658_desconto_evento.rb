class DescontoEvento < ActiveRecord::Migration
  def self.up
    add_column :descontos,  :evento_id, :integer
  end

  def self.down
    remove_column :descontos, :evento_id
  end
end
