class ReservaEmenta < ActiveRecord::Migration
  def self.up
    add_column  :reservas,  :ementa,  :string
  end

  def self.down
    remove_column  :reservas,  :ementa
  end
end
