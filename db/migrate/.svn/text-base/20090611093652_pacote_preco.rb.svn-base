class PacotePreco < ActiveRecord::Migration
  def self.up
    remove_column :pacote_produtos, :preco_id
    add_column    :pacote_produtos, :produto_id, :integer
  end

  def self.down
    add_column      :pacote_produtos, :preco_id, :integer
    remove_column   :pacote_produtos, :produto_id
  end
end
