class CreatePacoteIgnoreProdutos < ActiveRecord::Migration
  def self.up
    create_table :pacote_ignore_produtos do |t|
      t.integer   :pacote_id
      t.integer   :produto_id
    end
  end

  def self.down
    drop_table :pacote_ignore_produtos
  end
end
