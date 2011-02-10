class SemanticaCampos2 < ActiveRecord::Migration
  def self.up
    add_column  :campos, :is_morada, :boolean
    add_column  :campos, :is_codigo_postal, :boolean
    add_column  :campos, :is_localidade, :boolean
    add_column  :campos, :is_telemovel, :boolean
  end

  def self.down
    remove_column  :campos, :is_morada
    remove_column  :campos, :is_codigo_postal
    remove_column  :campos, :is_localidade
    remove_column  :campos, :is_telemovel
  end
end
