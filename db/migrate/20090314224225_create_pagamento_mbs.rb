class CreatePagamentoMbs < ActiveRecord::Migration
  def self.up
    create_table :pagamento_mbs do |t|
      t.string    :referencia
      t.datetime  :data
      t.decimal   :valor, :precision => 8, :scale => 2
      t.string    :terminal
      t.decimal   :tarifa, :precision => 8, :scale => 2
      t.decimal   :valorliquido, :precision => 8, :scale => 2
      t.integer   :pagamento_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pagamento_mbs
  end
end
