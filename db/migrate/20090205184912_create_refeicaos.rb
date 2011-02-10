class CreateRefeicaos < ActiveRecord::Migration
  def self.up
    create_table :refeicaos do |t|
      t.string  :nome
      t.timestamps
    end
  end

  def self.down
    drop_table :refeicaos
  end
end
