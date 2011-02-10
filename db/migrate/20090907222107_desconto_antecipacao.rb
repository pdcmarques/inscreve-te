class DescontoAntecipacao < ActiveRecord::Migration
  def self.up
    add_column  :eventos, :desconto_antecipacao,  :integer
    add_column  :eventos, :data_limite_desconto_antecipacao,  :datetime
  end

  def self.down
    remove_column  :eventos, :desconto_antecipacao
    remove_column  :eventos, :data_limite_desconto_antecipacao
  end
end
