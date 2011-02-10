class CreateCampos < ActiveRecord::Migration
  def self.up
    create_table :campos do |t|
      t.string      :nome
      t.string      :label
      t.string      :tipo
      t.integer     :tamanho
      t.string      :nota
      t.boolean     :mostra_tabela
      t.boolean     :mostra_inserir
      t.boolean     :mostra_detalhe
      t.boolean     :mostra_update
      t.integer     :lista_valores_id
      t.integer     :grupo_campos_id
      t.timestamps
    end
  end

  def self.down
    drop_table :campos
  end
end
