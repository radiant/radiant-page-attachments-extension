require File.dirname(__FILE__) + '/../test_helper'

class PageAttachmentsExtensionTest < Test::Unit::TestCase

  fixtures :page_attachments, :pages, :users
  test_helper :pages, :render

  # Replace this with your real tests.
  def setup
    @page = pages(:homepage)
  end

  def test_initialization
    assert_equal RAILS_ROOT + '/vendor/extensions/page_attachments', PageAttachmentsExtension.root
    assert_equal 'Page Attachments', PageAttachmentsExtension.extension_name
  end

  def test_module_inclusion
    assert Page.included_modules.include?(PageAttachmentTags)
    assert Page.included_modules.include?(PageAttachmentAssociations)
    assert UserActionObserver.included_modules.include?(ObservePageAttachments)
        assert ActiveRecord::Base.included_modules.include?(ActiveRecord::Acts::List)
        assert Technoweenie::AttachmentFu

    assert UserActionObserver.methods.include?('observed_class')
    #assert_equal UserActionObserver.instance.observed_class, [User, Page, Layout, Snippet, Asset]
  end

  def test_page_instance_methods
    assert Page.instance_methods.include?("attachments")
    assert Page.instance_methods.include?("attachments=")
    assert Page.instance_methods.include?("attachment")
    assert Page.instance_methods.include?("add_attachments")
    assert Page.instance_methods.include?("add_attachments=")
    assert Page.instance_methods.include?("save_attachments")

    assert Page.instance_methods.include?("tag:attachment")
    [:content_type, :size, :width, :height, :date, :image, :link, :author, :title, :short_title, :short_description, :short_filename, :description, :position].each do |key|
      assert Page.instance_methods.include?("tag:attachment:#{key}")
    end
  end

  def test_global_tags
    img = page_attachments(:rails_png)
    txt = page_attachments(:foo_txt)

    [:url, :content_type, :size, :width, :height, :date, :image, :link, :author, :title].each do |key|
      assert_render_error "'name' attribute required", "<r:attachment:#{key} />", '/'
    end

    assert_renders "", "<r:attachment></r:attachment>", "/"
    assert_renders img.public_filename, '<r:attachment:url name="rails.png" />', '/'
    assert_renders img.title, '<r:attachment:title name="rails.png" />', '/'
    assert_renders img.content_type, '<r:attachment:content_type name="rails.png" />', '/'

    assert_renders img.size.to_s, '<r:attachment:size name="rails.png" />', '/'
    assert_renders img.size.to_s, '<r:attachment:size name="rails.png" units="blargobytes" />', '/'
    assert_renders "1.75", '<r:attachment:size name="rails.png" units="kilobytes" />', '/'

    assert_renders img.width.to_s, '<r:attachment:width name="rails.png" />', '/'
    assert_renders img.height.to_s, '<r:attachment:height name="rails.png" />', '/'
    assert_renders img.content_type, '<r:attachment:content_type name="rails.png" />', '/'
    assert_renders img.created_at.strftime("%Y-%m-%d"), '<r:attachment:date name="rails.png" format="%Y-%m-%d" />', '/'
    assert_renders img.created_by.name, '<r:attachment:author name="rails.png" />', '/'
        assert_renders "", '<r:attachment:height name="foo.txt"/>','/'
        assert_renders "", '<r:attachment:width name="foo.txt"/>','/'

    assert_renders %{<img src="#{img.public_filename}" />}, '<r:attachment:image name="rails.png" />', '/'
    assert_renders %{<img src="#{img.public_filename}" style="float: right;" />}, '<r:attachment:image name="rails.png" style="float: right;"/>', '/'

    assert_renders %{<a href="#{img.public_filename}">rails.png</a>}, '<r:attachment:link name="rails.png" />', '/'
    assert_renders %{<a href="#{img.public_filename}" id="mylink">rails.png</a>}, '<r:attachment:link name="rails.png" id="mylink" />', '/'
    assert_renders %{<a href="#{img.public_filename}">Rails</a>}, '<r:attachment:link name="rails.png">Rails</r:attachment:link>', '/'
    assert_renders %{<a href="#{img.public_filename}">Rails</a>}, '<r:attachment:link name="rails.png" label="Rails"/>', '/'

        assert_renders %{Rails logo},'<r:attachment:title name="rails.png"/>','/'
        assert_renders %{Rails logo},'<r:attachment:short_title name="rails.png"/>','/'
        assert_renders %{The awesome Rails logo.},'<r:attachment:description name="rails.png"/>','/'

        assert_renders %{The awesome ...},'<r:attachment:short_description name="rails.png"/>','/'
        assert_renders %{The aweso ...},'<r:attachment:short_description name="rails.png" length="13" />','/'
        assert_renders %{The awesome Rails logo.}, '<r:attachment:short_description name="rails.png" length="35" />','/'

        assert_renders %{The awesome....}, '<r:attachment:short_description name="rails.png" length="15" suffix="...." />','/'

        assert_renders %{rails.png},'<r:attachment:filename name="rails.png"/>','/'
        assert_renders %{rails.png},'<r:attachment:short_filename name="rails.png"/>','/'
        assert_renders %{rails...},'<r:attachment:short_filename name="rails.png" suffix="..." length="8" />','/'

    assert_render_error "attachment is not an image.", '<r:attachment:image name="foo.txt" />', '/'
  end

  def test_positions
          img = page_attachments(:rails_png)
          txt = page_attachments(:foo_txt)
          assert_equal 1, img.position
          assert_equal 2, txt.position
          img.move_lower
          txt.reload
          assert_equal 2, img.position
          assert_equal 1, txt.position
  end

  def test_iteration
    img = page_attachments(:rails_png)
    txt = page_attachments(:foo_txt)

    assert_renders "* * ", "<r:attachment:each>* </r:attachment:each>", '/'
    assert_renders %{<a href="#{txt.public_filename}">foo.txt</a><a href="#{img.public_filename}">rails.png</a>},
                  %{<r:attachment:each by="filename"><r:link/></r:attachment:each>}, '/'
  end

  def test_limit_offset
    img = page_attachments(:rails_png)
    txt = page_attachments(:foo_txt)

    assert_renders %{<a href="#{img.public_filename}">rails.png</a>},
                  %{<r:attachment:each limit="1" offset="1" by="filename"><r:link/></r:attachment:each>}, '/'
    assert_renders %{<a href="#{txt.public_filename}">foo.txt</a>},
                  %{<r:attachment:each limit="1" offset="0" by="filename"><r:link/></r:attachment:each>}, '/'
    assert_renders %{<a href="#{txt.public_filename}">foo.txt</a>},
                  %{<r:attachment:each limit="1" by="filename"><r:link/></r:attachment:each>}, '/'
    assert_renders %{<a href="#{img.public_filename}">rails.png</a>},
                  %{<r:attachment:each offset="1" by="filename"><r:link/></r:attachment:each>}, '/'
  end

  def test_attachment_inheritance
    @page = pages(:documentation)
    img = page_attachments(:rails_png)
    txt = page_attachments(:foo_txt)
    assert_renders img.public_filename, '<r:attachment:url name="rails.png" />', '/documentation'
    assert_renders txt.public_filename, '<r:attachment:url name="foo.txt" />', '/documentation'
  end

  def test_filter_by_extension
    assert_renders "rails.png", %{<r:attachment:each extensions="png"><r:filename/></r:attachment:each>}
    assert_renders "rails.pngfoo.txt", %{<r:attachment:each extensions="png|txt"><r:filename/></r:attachment:each>}
  end

  def test_if_attachment_tag
    assert_renders "content", %{<r:if_attachments>content</r:if_attachments>}
    assert_renders "", %{<r:if_attachments min_count="3">content</r:if_attachments>}
    assert_renders "content", %{<r:if_attachments min_count="1" extensions="png">content</r:if_attachments>}
  end

  def test_extension_tag
    assert_renders "pngtxt", %{<r:attachment:each><r:extension/></r:attachment:each>}
  end
end
