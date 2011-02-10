class CreateI18nLocales < ActiveRecord::Migration
  def self.up
    create_table :i18n_locales do |t|
      t.string      :codigo_local
      t.string      :nome
      t.string      :pais
      t.string      :iso_pais
      t.string      :lingua
      t.string      :iso_moeda
      t.string      :simbolo_moeda
      t.string      :nbr_format
      t.string      :short_date_format
      t.string      :long_date_format
      t.string      :time_format
      t.timestamps
    end
    
    add_column  :eventos, :default_locale,  :string
    add_column  :eventos, :moeda,  :string
  end

  def self.down
    drop_table :i18n_locales
    
    remove_column  :eventos, :default_locale
    remove_column  :eventos, :moeda
  end
end
