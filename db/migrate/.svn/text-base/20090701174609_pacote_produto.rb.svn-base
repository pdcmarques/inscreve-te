class PacoteProduto < ActiveRecord::Migration
  def self.up
    remove_column :pacote_produtos,  :descricao
    remove_column :pacote_produtos,  :nome
    
    add_column    :pacote_produtos,  :pacote_id, :integer
  end

  def self.down
    add_column :pacote_produtos,  :descricao, :string
    add_column :pacote_produtos,  :nome, :string
    
    remove_column :pacote_produtos,  :pacote_id
  end
end
