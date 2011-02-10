class EntidadeEmails < ActiveRecord::Migration
  def self.up
    add_column  :entidades,   :support_email,   :string
    add_column  :entidades,   :contacts_email,   :string
  end

  def self.down
    remove_column  :entidades,   :support_email
    remove_column  :entidades,   :contacts_email
  end
end
