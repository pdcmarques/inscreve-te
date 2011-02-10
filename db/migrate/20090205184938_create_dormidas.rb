class CreateDormidas < ActiveRecord::Migration
  def self.up
    create_table :dormidas do |t|
      t.string  :nome
      t.timestamps
    end
  end

  def self.down
    drop_table :dormidas
  end
end
