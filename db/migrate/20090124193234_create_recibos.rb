class CreateRecibos < ActiveRecord::Migration
  def self.up
    create_table :recibos do |t|
      t.integer   :igreja_id
      t.string    :nome
      t.datetime  :data
      t.boolean   :pago
      t.string    :meio_pagamento
      t.timestamps
    end
  end

  def self.down
    drop_table :recibos
  end
end
