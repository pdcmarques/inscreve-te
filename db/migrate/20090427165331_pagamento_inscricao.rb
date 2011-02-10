class PagamentoInscricao < ActiveRecord::Migration
  def self.up
    add_column :pagamentos, :inscricao_id, :integer
  end

  def self.down
    remove_column :pagamentos, :inscricao_id
  end
end
