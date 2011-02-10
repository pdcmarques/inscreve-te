class InscricoesInfoComplementar < ActiveRecord::Migration
  def self.up
    add_column :inscricaos, :nome_cracha, :string
    add_column :inscricaos, :n_camas_extra, :string
  end

  def self.down
    remove_column :inscricaos, :nome_cracha
    remove_column :inscricaos, :n_camas_extra
  end
end
