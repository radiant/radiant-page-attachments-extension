class AddPageAttachmentsTitle < ActiveRecord::Migration
  def self.up
    add_column :page_attachments, :title, :string
  end
  
  def self.down
    remove_column :page_attachments, :title
  end
end