class CreateEstadoReservas < ActiveRecord::Migration
  def self.up
    create_table :estado_reservas do |t|
      t.string      :nome
      t.string      :descricao
      t.string      :icon
      t.boolean     :final_state
      t.boolean     :send_email_state
      t.text        :email_message
      t.boolean     :warning_state
      t.integer     :reserva_inscricao_id
      t.timestamps
    end
  end

  def self.down
    drop_table :estado_reservas
  end
end
