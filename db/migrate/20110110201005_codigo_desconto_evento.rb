class CodigoDescontoEvento < ActiveRecord::Migration
  def self.up
    add_column :codigo_descontos, :entidade_id, :integer
    add_column :codigo_descontos, :evento_id, :integer
  end

  def self.down
    remove_column :codigo_descontos, :entidade_id
    remove_column :codigo_descontos, :evento_id
  end
end
