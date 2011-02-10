class DescontosIdades < ActiveRecord::Migration
  def self.up
    add_column  :descontos,  :idade_min,   :integer
    add_column  :descontos,  :idade_max,   :integer
  end

  def self.down
    remove_column  :descontos,  :idade_min
    remove_column  :descontos,  :idade_max
  end
end
