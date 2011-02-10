class ReciboNif < ActiveRecord::Migration
  def self.up
    add_column  :recibos, :nif, :string
  end

  def self.down
    remove_column  :recibos, :nif
  end
end
