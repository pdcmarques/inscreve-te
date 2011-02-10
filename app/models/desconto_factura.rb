class DescontoFactura < ActiveRecord::Base
  belongs_to :recibo
  belongs_to  :desconto
end
