class MoradasIgrejas < ActiveRecord::Migration
  def self.up
    add_column :igrejas, :morada, :string
    add_column :igrejas, :codigo_postal, :string
  end

  def self.down
    remove_column :igrejas, :morada
    remove_column :igrejas, :codigo_postal
  end
end
