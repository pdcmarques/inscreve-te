class Campo < ActiveRecord::Base
  belongs_to  :grupo_campos
  belongs_to  :lista_valores
  has_many    :eventos,    :through => :eventos_grupos_campos
  has_many    :inscricaos, :through => :inscricaos_campos
  has_many    :campo_produtos
  
  #acts_as_translatable  :attributes => [:label]
  
  #include StringTranslator
  
  
end
