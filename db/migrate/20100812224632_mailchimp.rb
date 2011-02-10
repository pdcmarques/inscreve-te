class Mailchimp < ActiveRecord::Migration
  def self.up
    add_column :eventos, :mailchimp_api_key, :string
    add_column :eventos, :mailchimp_list_id, :integer
    add_column :campos, :mailchimp_tag, :string
  end

  def self.down
    remove_column :eventos, :mailchimp_api_key
    remove_column :eventos, :mailchimp_list_id
    remove_column :campos, :mailchimp_tag
  end
end
