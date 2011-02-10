class CreateGrupoInscricoes < ActiveRecord::Migration
  def self.up
    create_table :grupo_inscricoes do |t|
      t.column      :inscricao_id,  :integer
      t.timestamps
    end
    add_column  :eventos, :group_based, :boolean
    add_column  :inscricaos, :grupo_inscricoes_id, :integer
    add_column  :inscricaos, :grupo_responsible_relation, :string
  end

  def self.down
    drop_table :grupo_inscricoes
    remove_column  :eventos, :group_based
    remove_column  :inscricaos, :grupo_inscricoes_id
    remove_column  :inscricaos, :grupo_responsible_relation
  end
end
