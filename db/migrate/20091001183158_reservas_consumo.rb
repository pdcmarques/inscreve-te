class ReservasConsumo < ActiveRecord::Migration
  def self.up
    add_column  :inscricao_reservas,  :consumo_id,  :integer
  end

  def self.down
    remove_column  :inscricao_reservas,  :consumo_id
  end
end
