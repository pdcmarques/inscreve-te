class CreateEventos < ActiveRecord::Migration
  def self.up
    create_table :eventos do |t|
      t.string    :nome
      t.string    :nome_curto
      t.string    :descricao
      t.integer   :entidade_id
      t.string    :responsavel
      t.string    :email_responsavel
      t.string    :telefone_responsavel
      t.string    :fax_responsavel
      t.datetime  :data_inicio
      t.datetime  :data_fim
      t.boolean   :inscricoes_abertas
      t.boolean   :activo
      t.boolean   :publico
      t.string    :codigo
      t.string    :imagem
      t.decimal   :preco_base
      t.boolean   :preco_fixo
      t.timestamps
    end
    
    add_column :inscricaos, :evento_id, :int
  end

  def self.down
    drop_table :eventos
    remove_column :inscricaos, :evento_id
  end
end
