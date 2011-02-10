class CreateValors < ActiveRecord::Migration
  def self.up
    create_table :valors do |t|
      t.string      :valor
      t.string      :descricao
      t.integer     :ordem
      t.boolean     :only_master_admin
      t.boolean     :only_event_admin
      t.integer     :lista_valores_id
      t.timestamps
    end
  end

  def self.down
    drop_table :valors
  end
end
