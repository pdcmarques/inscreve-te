class ListaValoresClass < ActiveRecord::Migration
  def self.up
    add_column :lista_valores, :class_name, :string
    add_column :lista_valores, :value_field, :string
    add_column :lista_valores, :text_field, :string
    add_column :lista_valores, :condition, :string
  end

  def self.down
    remove_column :lista_valores, :class
    remove_column :lista_valores, :value_field
    remove_column :lista_valores, :text_field
    remove_column :lista_valores, :condition
  end
end
