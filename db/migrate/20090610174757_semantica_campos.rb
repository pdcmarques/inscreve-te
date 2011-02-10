class SemanticaCampos < ActiveRecord::Migration
  def self.up
    add_column  :campos, :is_nome, :boolean
    add_column  :campos, :is_email, :boolean
    add_column  :campos, :is_data_nascimento, :boolean
    add_column  :campos, :is_igreja, :boolean
    add_column  :campos, :is_grupo_inscricoes, :boolean
    add_column  :campos, :is_grupo_inscricoes_relation, :boolean
  end

  def self.down
    remove_column  :campos, :is_nome
    remove_column  :campos, :is_email
    remove_column  :campos, :is_data_nascimento
    remove_column  :campos, :is_igreja
    remove_column  :campos, :is_grupo_inscricoes
    remove_column  :campos, :is_grupo_inscricoes_relation
  end
end
