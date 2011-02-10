class EventosGruposCampos < ActiveRecord::Base
  belongs_to  :evento
  belongs_to  :grupo_campos
end
