class CreateIgrejamgs < ActiveRecord::Migration
  def self.up
    create_table :igrejamgs do |t|
      t.string        :nome
      t.string        :morada
      t.string        :codigo_postal
      t.string        :localidade
      t.string        :telefone
      t.string        :fax
      t.string        :email
      t.string        :nr_membros  
      t.string        :nr_simpatizantes
      t.timestamps
    end
  end

  def self.down
    drop_table :igrejamgs
  end
end
