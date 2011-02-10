class InfoFacturacao < ActiveRecord::Migration
  def self.up
    add_column  :recibos,  :morada1,  :string
    add_column  :recibos,  :morada2,  :string
    add_column  :recibos,  :codigo_postal,  :string
    add_column  :recibos,  :localidade,  :string
    add_column  :entidades,  :nif,  :string
  end

  def self.down
    remove_column  :recibos,  :morada1
    remove_column  :recibos,  :morada2
    remove_column  :recibos,  :codigo_postal
    remove_column  :recibos,  :localidade
    remove_column  :entidades,  :nif
  end
end
