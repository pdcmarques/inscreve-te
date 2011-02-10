class Consumo < ActiveRecord::Base
    belongs_to  :inscricao
    belongs_to  :recibo
    belongs_to  :produto
    has_many    :inscricao_reservas, :dependent => :delete_all
end
