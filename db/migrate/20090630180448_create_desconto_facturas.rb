class CreateDescontoFacturas < ActiveRecord::Migration
  def self.up
    create_table :desconto_facturas do |t|
      t.integer :desconto_id
      t.integer :recibo_id
      t.timestamps
    end
  end

  def self.down
    drop_table :desconto_facturas
  end
end
