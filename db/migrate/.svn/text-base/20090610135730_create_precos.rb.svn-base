class CreatePrecos < ActiveRecord::Migration
  def self.up
    create_table :precos do |t|
      t.column :produto_id,                :integer
      t.column :preco,                     :decimal
      t.column :idade_min,                 :integer
      t.column :idade_max,                 :integer
      t.column :data_min,                  :datetime
      t.column :data_max,                  :datetime
      t.column :data_inscricao,            :boolean
      t.column :data_pagamento,            :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :precos
  end
end
