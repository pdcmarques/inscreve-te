class MailchimpUsersList < ActiveRecord::Migration
  def self.up
    add_column  :entidades, :mailchimp_users_list_id,  :string
  end

  def self.down
    remove_column  :entidades, :mailchimp_users_list_id
  end
end
