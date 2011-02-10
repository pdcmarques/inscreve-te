class Evento < ActiveRecord::Base
  belongs_to  :entidade
  has_many    :inscricaos
  has_many    :recibos
  has_many    :eventos_grupos_camposs
  has_many    :grupo_camposs, :through => :eventos_grupos_camposs
  has_many    :documentos
  has_many    :produtos
  has_many    :descontos
end
