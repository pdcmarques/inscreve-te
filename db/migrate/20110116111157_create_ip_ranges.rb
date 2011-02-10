class CreateIpRanges < ActiveRecord::Migration
  def self.up
    create_table :ip_ranges do |t|
      t.string   :start_ip
      t.string   :end_ip
      t.integer  :start_nbr
      t.integer  :end_nbr
      t.string   :country_code
      t.string   :country_name
      t.timestamps
    end
  end

  def self.down
    drop_table :ip_ranges
  end
end
