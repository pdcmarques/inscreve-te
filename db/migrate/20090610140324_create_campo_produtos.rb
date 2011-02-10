class CreateCampoProdutos < ActiveRecord::Migration
  def self.up
    create_table :campo_produtos do |t|
      t.column      :campo_id,            :integer
      t.column      :produto_id,          :integer
      t.column      :comparison_operand,  :string
      t.column      :comparison_operator, :string
      t.column      :ruby_literal_exp,    :string
      t.timestamps
    end
  end

  def self.down
    drop_table :campo_produtos
  end
end
