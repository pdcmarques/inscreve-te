class PacoteProdutos < ActiveRecord::Base
  belongs_to  :produto
  belongs_to  :pacote
  
end
