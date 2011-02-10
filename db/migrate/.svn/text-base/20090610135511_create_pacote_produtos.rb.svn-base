class CreatePacoteProdutos < ActiveRecord::Migration
  def self.up
    create_table :pacote_produtos do |t|
      t.column :nome,                      :string
      t.column :descricao,                 :string
      t.column :preco_id,                  :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :pacote_produtos
  end
end
