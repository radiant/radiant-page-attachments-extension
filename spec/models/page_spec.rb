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

    Page.instance_methods.should include("tag:attachment")
    [:content_type, :size, :width, :height, :date, :image, :link, :author, :title, :short_title, :short_description, :short_filename, :description, :position].each do |key|
      Page.instance_methods.should include("tag:attachment:#{key}")
    end
  end
  
  it "should receive nested attributes for attachments" do
    page = pages(:home)
    page.attachments.length.should == 2
    file = 
    
    page.attachments_attributes = [{:uploaded_data => fixture_file_upload("#{PageAttachmentsExtension.root}/spec/fixtures/rails.png", 'image/png')}]
    page.save!
    page.reload.attachments.length.should == 1
  end
  
end
