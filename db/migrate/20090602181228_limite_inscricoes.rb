class LimiteInscricoes < ActiveRecord::Migration
  def self.up
    add_column :eventos, :limite_inscricoes_aviso, :integer
    add_column :eventos, :limite_inscricoes_maximo, :integer
  end

  def self.down
    remove_column :eventos, :limite_inscricoes_aviso
    remove_column :eventos, :limite_inscricoes_maximo
  end
end
