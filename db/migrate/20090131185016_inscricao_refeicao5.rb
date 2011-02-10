class InscricaoRefeicao5 < ActiveRecord::Migration
  def self.up
    add_column :inscricaos, :refeicao5, :string
  end

  def self.down
    remove_column :inscricaos, :refeicao5
  end
end
