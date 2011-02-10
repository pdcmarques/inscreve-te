class CreatePacotes < ActiveRecord::Migration
  def self.up
    create_table :pacotes do |t|
      t.string  :nome
      t.string  :descricao
      t.integer :produto_id
      t.timestamps
    end
  end

  def self.down
    drop_table :pacotes
  end
end
