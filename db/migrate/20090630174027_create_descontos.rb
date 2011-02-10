class CreateDescontos < ActiveRecord::Migration
  def self.up
    create_table :descontos do |t|
      t.string  :descricao
      t.decimal :percentagem
      t.decimal :absoluto
      t.integer :produto_id
      t.boolean :todos_produtos
      t.timestamps
    end
  end

  def self.down
    drop_table :descontos
  end
end
