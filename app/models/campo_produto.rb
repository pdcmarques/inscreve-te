class CampoProduto < ActiveRecord::Base
  belongs_to  :campo
  belongs_to     :produto
end
