class ReservaProduto < ActiveRecord::Base
  belongs_to    :reserva
  has_one       :produto
  belongs_to    :campo
end
