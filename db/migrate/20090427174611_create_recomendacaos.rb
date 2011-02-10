class CreateRecomendacaos < ActiveRecord::Migration
  def self.up
    create_table :recomendacaos do |t|
      t.integer     :user_id
      t.integer     :inscricao_id
      t.string      :assinatura
      t.timestamps
    end
    add_column :eventos, :precisa_recomendacao, :bool
  end

  def self.down
    drop_table :recomendacaos
    remove_column :eventos, :precisa_recomendacao
  end
end
