class CreateInscricaoReservas < ActiveRecord::Migration
  def self.up
    create_table :inscricao_reservas do |t|
      t.integer :inscricao_id
      t.integer :reserva_id
      t.timestamps
    end
  end

  def self.down
    drop_table :inscricao_reservas
  end
end
