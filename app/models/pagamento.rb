class Pagamento < ActiveRecord::Base
  belongs_to :recibo
  belongs_to :inscricao
  has_one :pagamento_mb
  belongs_to :tipo_pagamento
end
