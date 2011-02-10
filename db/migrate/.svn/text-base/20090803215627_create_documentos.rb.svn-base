class CreateDocumentos < ActiveRecord::Migration
  def self.up
    create_table :documentos do |t|
      t.string :nome_documento
      t.string :descricao_documento
      t.boolean :is_imagem
      t.boolean :is_excel
      t.boolean :is_word
      t.boolean :is_pdf
      t.string  :url
      t.boolean :is_instrucoes_formulario
      t.boolean :is_precario
      t.boolean :is_event_banner
      t.boolean :is_event_poster
      t.boolean :is_event_icon
      t.integer :evento_id
      t.integer :order
      t.timestamps
    end
  end

  def self.down
    drop_table :documentos
  end
end
