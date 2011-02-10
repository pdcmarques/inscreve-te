class CreateTipoPagamentos < ActiveRecord::Migration
  def self.up
    create_table :tipo_pagamentos do |t|
      t.string  :nome
      t.string  :nome_curto
      t.string  :codigo
      t.timestamps
    end
    
    add_column  :pagamentos, :tipo_pagamento_id, :integer
  end

  def self.down
    drop_table :tipo_pagamentos
    remove_column  :pagamentos, :tipo_pagamento_id
  end
end
