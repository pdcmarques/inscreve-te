class DataLimiteDesconto < ActiveRecord::Migration
  def self.up
    add_column  :eventos, :data_limite_desconto_pagamento_antecipado, :datetime
    add_column  :eventos, :data_limite_pagamento_total, :datetime
    add_column  :eventos, :data_limite_pagamento_taxa, :datetime
  end

  def self.down
    remove_column :eventos, :data_limite_desconto_pagamento_antecipado
    remove_column :eventos, :data_limite_pagamento_total
    remove_column :eventos, :data_limite_pagamento_taxa
  end
end
