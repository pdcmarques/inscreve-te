class CreatePagamentos < ActiveRecord::Migration
  def self.up
    create_table :pagamentos do |t|
      t.datetime  :data
      t.decimal   :valor
      t.integer   :recibo_id
      t.string    :observacoes
      t.timestamps
    end
  end

  def self.down
    drop_table :pagamentos
  end
end
