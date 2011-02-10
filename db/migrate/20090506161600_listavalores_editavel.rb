class ListavaloresEditavel < ActiveRecord::Migration
  def self.up
    add_column :lista_valores, :editavel, :boolean
  end

  def self.down
    remove_column :lista_valores, :editavel
  end
end
