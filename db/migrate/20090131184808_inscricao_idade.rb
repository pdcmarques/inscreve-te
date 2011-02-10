class InscricaoIdade < ActiveRecord::Migration
  def self.up
    add_column :inscricaos, :idade, :integer
  end

  def self.down
    remove_column :inscricaos, :idade
  end
end
