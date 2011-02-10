class RefeicoesDormidas < ActiveRecord::Migration
  def self.up
    add_column :inscricaos, :refeicao1_id, :integer
    add_column :inscricaos, :refeicao2_id, :integer
    add_column :inscricaos, :refeicao3_id, :integer
    add_column :inscricaos, :refeicao4_id, :integer
    add_column :inscricaos, :refeicao5_id, :integer
    
    add_column :inscricaos, :noite1_id, :integer
    add_column :inscricaos, :noite2_id, :integer
    
    add_column :inscricaos, :estatuto_id, :integer
    
    remove_column :inscricaos, :refeicao1
    remove_column :inscricaos, :refeicao2
    remove_column :inscricaos, :refeicao3
    remove_column :inscricaos, :refeicao4
    remove_column :inscricaos, :refeicao5
    
    remove_column :inscricaos, :noite1
    remove_column :inscricaos, :noite2
    
    remove_column :inscricaos, :estatuto
  end

  def self.down
    
    remove_column :inscricaos, :refeicao1_id
    remove_column :inscricaos, :refeicao2_id
    remove_column :inscricaos, :refeicao3_id
    remove_column :inscricaos, :refeicao4_id
    remove_column :inscricaos, :refeicao5_id
    
    remove_column :inscricaos, :noite1_id
    remove_column :inscricaos, :noite2_id
    
    remove_column :inscricaos, :estatuto_id
    
    add_column :inscricaos, :refeicao1, :string
    add_column :inscricaos, :refeicao2, :string
    add_column :inscricaos, :refeicao3, :string
    add_column :inscricaos, :refeicao4, :string
    add_column :inscricaos, :refeicao5, :string
    
    add_column :inscricaos, :noite1, :string
    add_column :inscricaos, :noite2, :string
    
    add_column :inscricaos, :estatuto, :string
  end
end
