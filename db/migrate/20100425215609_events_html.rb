class EventsHtml < ActiveRecord::Migration
  def self.up
    add_column :eventos, :pre_html, :text
    add_column :eventos, :pos_html, :text
  end

  def self.down
    remove_column :eventos, :pre_html
    remove_column :eventos, :pos_html
  end
end
