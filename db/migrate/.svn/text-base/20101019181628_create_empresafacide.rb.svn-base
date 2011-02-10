class CreateEmpresafacide < ActiveRecord::Migration
  def self.up
    drop_table :empresa_facides
    create_table :empresafacides do |t|
      t.string  :nome
      t.string  :nif
      t.string  :morada
      t.string  :localidade
      t.string  :telefone
      t.string  :email
      t.timestamps
    end
  end

  def self.down
    drop_table :empresafacides
  end
end
