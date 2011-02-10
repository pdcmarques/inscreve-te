class ReciboDiasPrazo < ActiveRecord::Migration
  def self.up
    add_column  :recibos, :dias_que_faltam_para_taxa, :integer
    add_column  :recibos, :dias_que_faltam_para_total, :integer
  end

  def self.down
    remove_column  :recibos, :dias_que_faltam_para_taxa
    remove_column  :recibos, :dias_que_faltam_para_total
  end
end
