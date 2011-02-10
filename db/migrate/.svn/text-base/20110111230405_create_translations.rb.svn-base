class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.string      :string_code
      t.string      :string_value
      t.string      :codigo_locale
      t.timestamps
    end
  end

  def self.down
    drop_table :translations
  end
end
