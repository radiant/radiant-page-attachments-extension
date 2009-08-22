require File.dirname(__FILE__) + '/../spec_helper'

describe Page, 'page attachments' do
  dataset :pages, :page_attachments
  
  it "should include page attachment modules" do
    Page.included_modules.should include(PageAttachmentTags)
    Page.included_modules.should include(PageAttachmentAssociations)
  end
  
  it "should have attachment methods" do
    Page.instance_methods.should include("attachments")
    Page.instance_methods.should include("attachments=")
    Page.instance_methods.should include("attachment")
    Page.instance_methods.should include("add_attachments")
    Page.instance_methods.should include("add_attachments=")
    Page.instance_methods.should include("save_attachments")

    Page.instance_methods.should include("tag:attachment")
    [:content_type, :size, :width, :height, :date, :image, :link, :author, :title, :short_title, :short_description, :short_filename, :description, :position].each do |key|
      Page.instance_methods.should include("tag:attachment:#{key}")
    end
  end
  
end
