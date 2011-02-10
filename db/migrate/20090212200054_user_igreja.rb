class UserIgreja < ActiveRecord::Migration
  def self.up
    add_column  :users,   :igreja_id,   :integer
  end

  def self.down
    remove_column  :users,   :igreja_id
  end
end
