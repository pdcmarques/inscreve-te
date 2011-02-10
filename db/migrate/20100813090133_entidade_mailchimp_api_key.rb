class EntidadeMailchimpApiKey < ActiveRecord::Migration
  def self.up
    add_column  :entidades, :mailchimp_api_key, :string
  end

  def self.down
    remove_column  :entidades, :mailchimp_api_key
  end
end
