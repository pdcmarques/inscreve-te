class CreateIgrejasummits < ActiveRecord::Migration
  def self.up
    create_table :igrejasummits do |t|
      t.string        :nome
      t.string        :morada
      t.string        :codigo_postal
      t.string        :localidade
      t.string        :telefone
      t.string        :email
      t.timestamps
    end
  end

  def self.down
    drop_table :igrejasummits
  end
end