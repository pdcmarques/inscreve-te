class CreateConsumos < ActiveRecord::Migration
  def self.up
    create_table :consumos do |t|
      t.integer   :produto_id
      t.datetime  :data
      t.decimal   :preco
      t.string    :observacoes
      t.integer   :inscricao_id
      t.integer   :recibo_id
      t.timestamps
    end
  end

  def self.down
    drop_table :consumos
  end
end
