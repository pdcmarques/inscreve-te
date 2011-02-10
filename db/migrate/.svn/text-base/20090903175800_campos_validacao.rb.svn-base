class CamposValidacao < ActiveRecord::Migration
  def self.up
    add_column  :campos,  :maskRe,       :string
    add_column  :campos,  :tamanho_min,  :integer
    add_column  :campos,  :regex_text,   :string
  end

  def self.down
    remove_column  :campos,  :maskRe
    remove_column  :campos,  :tamanho_min
    remove_column  :campos,  :regex_text
  end
end
