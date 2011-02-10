class EventoRefmb < ActiveRecord::Migration
  def self.up
    add_column  :eventos, :referencia_mb_min, :integer
    add_column  :eventos, :referencia_mb_max, :integer
  end

  def self.down
    remove_column :eventos, :referencia_mb_min
    remove_column :eventos, :referencia_mb_max
  end
end
