class ReservasCampos < ActiveRecord::Migration
  def self.up
    add_column  :reserva_produtos,  :campo_id,            :integer
    add_column  :reserva_produtos,  :comparison_operator,    :string
    add_column  :reserva_produtos,  :comparison_operand,    :string
  end

  def self.down
    remove_column :reserva_produtos,  :campo_id
    remove_column :reserva_produtos,  :comparison_operator
    remove_column :reserva_produtos,  :comparison_operand
  end
end
