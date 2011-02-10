class CreateCodigoDescontos < ActiveRecord::Migration
  def self.up
    create_table :codigo_descontos do |t|
      t.string      :codigo
      t.integer     :stock
      t.integer     :qtd_consumida
      t.integer     :user_id
      t.integer     :desconto_id
      t.timestamps

      t.timestamps
    end
  end

  def self.down
    drop_table :codigo_descontos
  end
end
