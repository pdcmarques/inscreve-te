class GrupoInscricoes < ActiveRecord::Base
  has_one   :inscricao
  has_many  :inscricaos
end
