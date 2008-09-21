class AddPageAttachmentsFields < ActiveRecord::Migration
  def self.up
    add_column :page_attachments,	:title,				:string
    add_column :page_attachments,	:description,		:string
    add_column :page_attachments,	:position,			:integer
    pages_with_attachments = PageAttachment.find_by_sql('select page_id from page_attachments where page_id is not null group by page_id')
    pages_with_attachments.each do |pa|
      attaches = PageAttachment.find(:all, :conditions => ['page_id = ?',pa.page_id], :order => :id)
      i=1
      attaches.each do |attach|
        attach.position = i
        attach.save
        i = i + 1
      end
    end
  end

  def self.down
    remove_column :page_attachments, :title
    remove_column :page_attachments, :description
    remove_column :page_attachments, :position
  end
end
