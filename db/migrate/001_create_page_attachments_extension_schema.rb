class CreatePageAttachmentsExtensionSchema < ActiveRecord::Migration
  def self.up
    create_table "page_attachments" do |t|
      t.column "content_type", :string
      t.column "filename",     :string
      t.column "size",         :integer
      t.column "parent_id",    :integer
      t.column "thumbnail",    :string
      t.column "width",        :integer
      t.column "height",       :integer
      t.column "created_at",   :datetime
      t.column "created_by",   :integer
      t.column "updated_at",   :datetime
      t.column "updated_by",   :integer
      t.column "page_id",      :integer
    end
  end

  def self.down
    drop_table "page_attachments"
  end
end
