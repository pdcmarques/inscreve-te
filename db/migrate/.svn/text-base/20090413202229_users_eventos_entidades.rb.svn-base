class UsersEventosEntidades < ActiveRecord::Migration
  def self.up
    add_column :users, :evento_id, :int
    add_column :users, :entidade_id, :int
  end

  def self.down
    remove_column :users, :evento_id
    remove_column :users, :entidade_id
  end
end
