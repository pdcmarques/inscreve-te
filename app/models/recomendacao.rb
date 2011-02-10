class Recomendacao < ActiveRecord::Base
  belongs_to  :inscricao
  belongs_to  :user
  
end
