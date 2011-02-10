class CreateListaValores < ActiveRecord::Migration
  def self.up
    create_table :lista_valores do |t|
      t.string      :nome
      t.boolean     :activa
      t.timestamps
    end
  end

  def self.down
    drop_table :lista_valores
  end
end
