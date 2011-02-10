class TaxaInscricaoMinima < ActiveRecord::Migration
  def self.up
    add_column  :eventos, :taxa_inscricao_min,  :decimal
    add_column  :eventos, :taxa_inscricao_max,  :decimal
  end

  def self.down
    remove_column  :eventos, :taxa_inscricao_min
    remove_column  :eventos, :taxa_inscricao_max
  end
end
