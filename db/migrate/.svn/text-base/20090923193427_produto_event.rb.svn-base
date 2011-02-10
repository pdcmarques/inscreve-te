class ProdutoEvent < ActiveRecord::Migration
  def self.up
    add_column  :produtos,  :evento_id, :integer
    add_column  :produtos,  :entidade_id, :integer
  end

  def self.down
    remove_column  :produtos,  :evento_id
    remove_column  :produtos,  :entidade_id
  end
end
