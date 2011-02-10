class CreateEmpresaFacides < ActiveRecord::Migration
  def self.up
    create_table :empresa_facides do |t|
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
    drop_table :empresa_facides
  end
end
