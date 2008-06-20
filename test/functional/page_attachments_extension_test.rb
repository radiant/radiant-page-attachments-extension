require File.dirname(__FILE__) + '/../test_helper'

class PageAttachmentsExtensionTest < Test::Unit::TestCase

  fixtures :page_attachments, :pages, :users
  test_helper :render
  
  # Replace this with your real tests.
  def setup
    @page = pages(:homepage)
  end
  
  def test_initialization
    assert_equal RADIANT_ROOT + '/vendor/extensions/page_attachments', PageAttachmentsExtension.root
    assert_equal 'Page Attachments', PageAttachmentsExtension.extension_name
  end
  
  def test_module_inclusion
    assert Page.included_modules.include?(PageAttachmentTags)
    assert Page.included_modules.include?(PageAttachmentAssociations)
    assert UserActionObserver.included_modules.include?(ObservePageAttachments)
    assert ActiveRecord::Base.included_modules.include?(Technoweenie::ActsAsAttachment)
    
    assert Page.instance_methods.include?("attachments")
    assert Page.instance_methods.include?("attachments=")    
    assert Page.instance_methods.include?("attachment")    
    assert Page.instance_methods.include?("add_attachments")    
    assert Page.instance_methods.include?("add_attachments=")
    assert Page.instance_methods.include?("save_attachments")
    
    assert UserActionObserver.methods.include?('observed_class')
    #assert_equal UserActionObserver.instance.observed_class, [User, Page, Layout, Snippet, Asset]
    
    assert Page.instance_methods.include?("tag:attachment")
    [:content_type, :size, :width, :height, :date, :image, :link, :author].each do |key|
      assert Page.instance_methods.include?("tag:attachment:#{key}")
    end
  end
  
  def test_global_tags
    img = page_attachments(:rails_png)
    txt = page_attachments(:foo_txt)

    [:url, :content_type, :size, :width, :height, :date, :image, :link, :author].each do |key|
      assert_render_error "'name' attribute required", "<r:attachment:#{key} />", '/'
    end
    
    assert_renders "", "<r:attachment></r:attachment>", "/"
    assert_renders img.public_filename, '<r:attachment:url name="rails.png" />', '/'
    assert_renders img.content_type, '<r:attachment:content_type name="rails.png" />', '/'
    assert_renders img.size.to_s, '<r:attachment:size name="rails.png" />', '/'
    assert_renders img.width.to_s, '<r:attachment:width name="rails.png" />', '/'    
    assert_renders img.height.to_s, '<r:attachment:height name="rails.png" />', '/'
    assert_renders img.content_type, '<r:attachment:content_type name="rails.png" />', '/'
    assert_renders img.created_at.strftime("%Y-%m-%d"), '<r:attachment:date name="rails.png" format="%Y-%m-%d" />', '/'
    assert_renders img.created_by.name, '<r:attachment:author name="rails.png" />', '/'

    assert_renders %{<img src="#{img.public_filename}" />}, '<r:attachment:image name="rails.png" />', '/'
    assert_renders %{<img src="#{img.public_filename}" style="float: right;" />}, '<r:attachment:image name="rails.png" style="float: right;"/>', '/'
    
    assert_renders %{<a href="#{img.public_filename}">rails.png</a>}, '<r:attachment:link name="rails.png" />', '/'
    assert_renders %{<a href="#{img.public_filename}" id="mylink">rails.png</a>}, '<r:attachment:link name="rails.png" id="mylink" />', '/'
    assert_renders %{<a href="#{img.public_filename}">Rails</a>}, '<r:attachment:link name="rails.png">Rails</r:attachment:link>', '/'
    assert_renders %{<a href="#{img.public_filename}">Rails</a>}, '<r:attachment:link name="rails.png" label="Rails"/>', '/'
    
    assert_render_error "attachment is not an image.", '<r:attachment:image name="foo.txt" />', '/'
  end
  
  def test_iteration
    img = page_attachments(:rails_png)
    txt = page_attachments(:foo_txt)

    assert_renders "* * ", "<r:attachment:each>* </r:attachment:each>", '/'
    assert_renders %{<a href="#{txt.public_filename}">foo.txt</a><a href="#{img.public_filename}">rails.png</a>},
                  %{<r:attachment:each by="filename"><r:link/></r:attachment:each>}, '/'
  end
  
  def test_attachment_inheritance
    @page = pages(:documentation)
    img = page_attachments(:rails_png)
    txt = page_attachments(:foo_txt)
    assert_renders img.public_filename, '<r:attachment:url name="rails.png" />', '/documentation'
    assert_renders txt.public_filename, '<r:attachment:url name="foo.txt" />', '/documentation'
  end
end
