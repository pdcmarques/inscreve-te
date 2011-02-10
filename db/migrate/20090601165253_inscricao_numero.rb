class InscricaoNumero < ActiveRecord::Migration
  def self.up
    add_column :inscricaos, :numero, :integer
  end

  def self.down
    remove_column :inscricaos, :numero
  end
end
