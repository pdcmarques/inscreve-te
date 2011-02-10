class CreateEntidades < ActiveRecord::Migration
  def self.up
    create_table :entidades do |t|
      t.string      :nome
      t.string      :nome_curto
      t.string      :sigla
      t.string      :contacto
      t.string      :morada
      t.string      :email
      t.string      :telefone
      t.string      :fax
      t.string      :observacoes
      t.string      :logotipo
      t.timestamps
    end
  end

  def self.down
    drop_table :entidades
  end
end
