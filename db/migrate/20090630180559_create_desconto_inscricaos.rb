class CreateDescontoInscricaos < ActiveRecord::Migration
  def self.up
    create_table :desconto_inscricaos do |t|
      t.integer   :desconto_id
      t.integer   :inscricao_id
      t.timestamps
    end
  end

  def self.down
    drop_table :desconto_inscricaos
  end
end
