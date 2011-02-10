class CreateComunicacaos < ActiveRecord::Migration
  def self.up
    create_table :comunicacaos do |t|
      t.column      :assunto,         :string
      t.column      :corpo,           :text
      t.column      :user_id,         :integer
      t.column      :data,            :datetime
      t.column      :anexo,           :text
      t.column      :nome_anexo,      :string
      t.column      :tipo,            :string
      t.column      :comunicacao_id,  :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :comunicacaos
  end
end
