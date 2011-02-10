class ReciboEvento < ActiveRecord::Migration
  def self.up
    add_column :recibos, :evento_id, :int
  end

  def self.down
    remove_column :recibos, :evento_id
  end
end
