class AlterInscricaos < ActiveRecord::Migration
  def self.up
    change_column :eventos, :descricao, :text
    add_column :eventos, :taxa_inscricao, :decimal
    add_column :eventos, :multa, :decimal
    add_column :eventos, :n_dias_multa, :integer
  end

  def self.down
    change_column :eventos, :descricao, :string
    remove_column :eventos, :taxa_inscricao
    remove_column :eventos, :multa
    remove_column :eventos, :n_dias_multa
  end
end
