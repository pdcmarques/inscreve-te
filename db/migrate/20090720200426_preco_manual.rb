class PrecoManual < ActiveRecord::Migration
  def self.up
    add_column  :inscricaos, :preco_manual,  :decimal, :precision => 10, :scale => 2
  end

  def self.down
    remove_colum :inscricaos, :preco_manual
  end
end
