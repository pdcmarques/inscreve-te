class DescontoPagamentoAntecipado < ActiveRecord::Migration
  def self.up
    add_column  :eventos, :desconto_pagamento_antecipado, :integer
    add_column  :eventos, :limite_pagamentos_para_desconto, :integer
    add_column  :eventos, :limite_montante_para_desconto,   :decimal
  end

  def self.down
    remove_column  :eventos, :desconto_pagamento_antecipado
    remove_column  :eventos, :limite_pagamentos_para_desconto
    remove_column  :eventos, :limite_montante_para_desconto
  end
end
