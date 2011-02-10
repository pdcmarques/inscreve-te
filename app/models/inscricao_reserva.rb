class InscricaoReserva < ActiveRecord::Base
  belongs_to    :inscricao
  belongs_to    :reserva
  has_many      :reserva_estados, :dependent => :delete_all
  has_one       :consumo
end
