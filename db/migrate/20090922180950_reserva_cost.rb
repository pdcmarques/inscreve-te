class ReservaCost < ActiveRecord::Migration
  def self.up
    add_column  :reservas,  :cost,  :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_column  :reservas,  :cost
  end
end
