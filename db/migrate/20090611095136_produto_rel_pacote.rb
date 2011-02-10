class ProdutoRelPacote < ActiveRecord::Migration
  def self.up
    add_column    :produtos, :pacote_produtos_id, :integer
  end

  def self.down
    remove_column    :produtos, :pacote_produtos_id
  end
end
