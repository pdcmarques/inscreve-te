class Produtos < ActiveRecord::Migration
  def self.up
    remove_column :produtos,  :preco
    remove_column :produtos,  :preco2
    remove_column :produtos,  :pacote_produtos_id
  end

  def self.down
    add_column :produtos,  :preco,  :decimal
    add_column :produtos,  :preco2, :decimal
    add_column :produtos,  :pacote_produtos_id, :integer
  end
end
