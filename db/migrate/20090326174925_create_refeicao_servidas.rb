class CreateRefeicaoServidas < ActiveRecord::Migration
  def self.up
    create_table :refeicao_servidas do |t|
      t.integer     :inscricao_id
      t.integer     :refeicao_id
      t.datetime    :data
      t.timestamps
    end
    
    add_column  :refeicaos,   :numero,   :integer
  end

  def self.down
    drop_table :refeicao_servidas
    remove_column  :refeicaos,   :numero
  end
end
