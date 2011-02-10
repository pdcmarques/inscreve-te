class CreateDescontoEstatutos < ActiveRecord::Migration
  def self.up
    create_table :desconto_estatutos do |t|
      t.integer   :desconto_id
      t.integer   :estatuto_id
      t.timestamps
    end
  end

  def self.down
    drop_table :desconto_estatutos
  end
end
