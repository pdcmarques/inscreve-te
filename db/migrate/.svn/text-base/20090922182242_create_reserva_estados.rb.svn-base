class CreateReservaEstados < ActiveRecord::Migration
  def self.up
    create_table :reserva_estados do |t|
      t.integer     :reserva_id
      t.integer     :estado_reserva_id
      t.datetime    :data_inicio
      t.datetime    :data_fim
      t.timestamps
    end
  end

  def self.down
    drop_table :reserva_estados
  end
end
