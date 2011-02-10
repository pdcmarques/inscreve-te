class CreateEventosGruposCampos < ActiveRecord::Migration
  def self.up
    create_table :eventos_grupos_campos do |t|
      t.integer     :evento_id
      t.integer     :grupo_campos_id
      t.timestamps
    end
  end

  def self.down
    drop_table :eventos_grupos_campos
  end
end
