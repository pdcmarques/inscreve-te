class CreateReservaProdutos < ActiveRecord::Migration
  def self.up
    create_table :reserva_produtos do |t|
      t.integer   :reserva_id
      t.integer   :produto_id
      t.timestamps
    end
  end

  def self.down
    drop_table :reserva_produtos
  end
end
