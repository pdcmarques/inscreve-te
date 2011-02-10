class InscricaoMoradas < ActiveRecord::Migration
  def self.up
    add_column  :inscricaos,  :morada,          :string
    add_column  :inscricaos,  :codigo_postal,   :string
    add_column  :inscricaos,  :localidade,      :string
    add_column  :inscricaos,  :telemovel,       :string
  end

  def self.down
    remove_column  :inscricaos,  :morada  
    remove_column  :inscricaos,  :codigo_postal
    remove_column  :inscricaos,  :localidade     
    remove_column  :inscricaos,  :telemovel
  end
end
