class Dormidas < ActiveRecord::Migration
  def self.up
    change_column :inscricaos, :noite1, :string, :default=>"0"
    change_column :inscricaos, :noite2, :string, :default=>"0"
  end

  def self.down
    change_column :inscricaos, :noite1, :boolean
    change_column :inscricaos, :noite2, :boolean
  end
end
