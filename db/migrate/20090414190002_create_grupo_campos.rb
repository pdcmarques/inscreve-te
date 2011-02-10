class CreateGrupoCampos < ActiveRecord::Migration
  def self.up
    create_table :grupo_campos do |t|
      t.string      :nome
      t.integer     :order
      t.string      :label
      t.timestamps
    end
  end

  def self.down
    drop_table :grupo_campos
  end
end
