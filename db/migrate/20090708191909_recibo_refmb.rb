class ReciboRefmb < ActiveRecord::Migration
  def self.up
    add_column  :recibos, :referencia_mb, :integer
  end

  def self.down
    remove_column  :recibos, :referencia_mb
  end
end
