class TaxaInscricao < ActiveRecord::Migration
  def self.up
    add_column  :produtos,  :is_taxa_inscricao,   :boolean
    add_column  :eventos,   :dias_para_pagamento_taxa,   :int
    add_column  :eventos,   :dias_para_pagamento_total,  :int
  end

  def self.down
    remove_column :produtos,  :is_taxa_inscricao
    remove_column  :eventos,   :dias_para_pagamento_taxa
    remove_column  :eventos,   :dias_para_pagamento_total
  end
end
