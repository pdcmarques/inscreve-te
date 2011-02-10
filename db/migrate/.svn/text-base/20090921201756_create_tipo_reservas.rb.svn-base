class CreateTipoReservas < ActiveRecord::Migration
  def self.up
    create_table :tipo_reservas do |t|
      t.string  :nome
      t.string  :descricao
      t.string  :icone
      t.timestamps
    end
  end

  def self.down
    drop_table :tipo_reservas
  end
end
