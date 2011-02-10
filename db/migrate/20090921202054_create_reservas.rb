class CreateReservas < ActiveRecord::Migration
  def self.up
    create_table :reservas do |t|
      t.string    :nome
      t.string    :nome_curto
      t.datetime  :data_consumo
      t.integer   :tipo_reserva_id
      t.integer   :stock
      t.timestamps
    end
  end

  def self.down
    drop_table :reservas
  end
end
