class CreateInscricaosCampos < ActiveRecord::Migration
  def self.up
    create_table :inscricaos_campos do |t|
      t.integer     :inscricao_id
      t.integer     :campo_id
      t.string      :string_value
      t.integer     :int_value
      t.decimal     :decimal_value
      t.datetime    :date_value
      t.integer     :lov_value
      t.timestamps
    end
  end

  def self.down
    drop_table :inscricaos_campos
  end
end
