class InscricaoReservaEstados < ActiveRecord::Migration
  def self.up
    add_column  :reserva_estados, :inscricao_reserva_id,  :integer
    remove_column  :reserva_estados, :reserva_id
  end

  def self.down
    remove_column  :reserva_estados, :inscricao_reserva_id
    add_column  :reserva_estados, :reserva_id,  :integer
  end

end
