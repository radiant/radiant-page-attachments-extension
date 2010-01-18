require File.dirname(__FILE__) + '/../spec_helper'

describe "page attachment tags" do
  dataset :pages, :page_attachments
  
  it "should raise an error when required attributes missing" do
    [:url, :content_type, :size, :width, :height, :date, :image, :link, :author, :title].each do |key|
      message = "'name' attribute required"
      page.should render("<r:attachment:#{key} />").with_error(message)
    end
  end
  
  it "<r:attachment /> should render nothing when empty" do
    page.should render("<r:attachment></r:attachment>").as("")
  end
  
  it "should render the URL tag" do
    page.should render('<r:attachment:url name="rails.png" />').as(img.public_filename)
  end
  it "should render the title tag" do
    page.should render('<r:attachment:title name="rails.png" />').as(img.title)
  end
  it "should render the content type" do
    page.should render('<r:attachment:content_type name="rails.png" />').as(img.content_type)
  end

  it "should render the size" do
    page.should render('<r:attachment:size name="rails.png" />').as(img.size.to_s)
  end
  it "should render the size in bytes when unit is invalid" do
    page.should render('<r:attachment:size name="rails.png" units="blargobytes" />').as(img.size.to_s)
  end
  it "should render the size in the units specified" do
    page.should render('<r:attachment:size name="rails.png" units="kilobytes" />').as('%.2f' % (img.size / 1024.00))
  end

  it "should render the width" do
    page.should render('<r:attachment:width name="rails.png" />').as(img.width.to_s)
  end
  it "should render the height" do
    page.should render('<r:attachment:height name="rails.png" />').as(img.height.to_s)
  end
  it "should render the date" do
    page.should render('<r:attachment:date name="rails.png" format="%Y-%m-%d" />').as(img.created_at.strftime("%Y-%m-%d"))
  end
  it "should render the author" do
    page.should render('<r:attachment:author name="rails.png" />').as(img.created_by.name)
  end
  it "should render empty width and height for non-images" do
    page.should render('<r:attachment:height name="foo.txt"/>').as("")
    page.should render('<r:attachment:width name="foo.txt"/>').as("")
  end
  
  it "should render image tag" do
    page.should render('<r:attachment:image name="rails.png" />').as(%{<img src="#{img.public_filename}" />})
  end
  it "should render image tag with HTML attributes" do
    page.should render('<r:attachment:image name="rails.png" style="float: right;"/>').as(%{<img src="#{img.public_filename}" style="float: right;" />})
  end
  it "should render link tag" do
    page.should render('<r:attachment:link name="rails.png" />').as(%{<a href="#{img.public_filename}">rails.png</a>})
  end
  it "should render link tag with HTML attributes" do
    page.should render('<r:attachment:link name="rails.png" id="mylink" />').as(%{<a href="#{img.public_filename}" id="mylink">rails.png</a>})
  end
  it "should render link tag" do
    page.should render('<r:attachment:link name="rails.png">Rails</r:attachment:link>').as(%{<a href="#{img.public_filename}">Rails</a>})
  end
  it "should render link tag with HTML attributes" do
    page.should render('<r:attachment:link name="rails.png" label="Rails"/>').as(%{<a href="#{img.public_filename}">Rails</a>})
  end
  
  it "should render the title" do
    page.should render('<r:attachment:title name="rails.png"/>').as(%{Rails logo})
  end
  it "should render the short title" do
    page.should render('<r:attachment:short_title name="rails.png"/>').as(%{Rails logo})
  end
  it "should render the description" do
    page.should render('<r:attachment:description name="rails.png"/>').as(%{The awesome Rails logo.})
  end
  it "should render the short description" do
    page.should render('<r:attachment:short_description name="rails.png"/>').as(%{The awesome ...})
  end
  it "should render the short description at the specified length" do
    page.should render('<r:attachment:short_description name="rails.png" length="13" />').as(%{The aweso ...})
  end
  it "should render the short description at a length greater than the description length" do
    page.should render('<r:attachment:short_description name="rails.png" length="35" />').as(%{The awesome Rails logo.})
  end
  it "should render the short description with a custom length and suffix" do
    page.should render('<r:attachment:short_description name="rails.png" length="15" suffix="...." />').as(%{The awesome....})
  end
  it "should render the filename" do
    page.should render('<r:attachment:filename name="rails.png"/>').as(%{rails.png})
  end
  it "should render the short filename" do
    page.should render('<r:attachment:short_filename name="rails.png"/>').as(%{rails.png})
  end
  it "should render the short filename with a custom length and suffix" do
    page.should render('<r:attachment:short_filename name="rails.png" suffix="..." length="8" />').as(%{rails...})
  end

  it "should render error when image tag used on non-image" do
    page.should render('<r:attachment:image name="foo.txt" />').with_error("attachment is not an image.")
  end
  
  it "should render the contents for each attachment" do
    page.should render("<r:attachment:each>* </r:attachment:each>").as("* * ")
  end
  it "should render contained tags for each attachment" do
    page.should render(%{<r:attachment:each by="filename"><r:link/></r:attachment:each>}).as(%{<a href="#{txt.public_filename}">foo.txt</a><a href="#{img.public_filename}">rails.png</a>})
  end
  
  it "should render the contents for each attachment with offset and limit" do
    page.should render(%{<r:attachment:each limit="1" offset="1" by="filename"><r:link/></r:attachment:each>}).as(%{<a href="#{img.public_filename}">rails.png</a>})
  end
  it "should render the contents for each attachment with limit, offset, and order column" do
    page.should render(%{<r:attachment:each limit="1" offset="0" by="filename"><r:link/></r:attachment:each>}).as(%{<a href="#{txt.public_filename}">foo.txt</a>})
  end
  it "should render the contents for each attachment with limit and order column" do
    page.should render(%{<r:attachment:each limit="1" by="filename"><r:link/></r:attachment:each>}).as(%{<a href="#{txt.public_filename}">foo.txt</a>})
  end
  it "should render the contents for each attachment with offset and order column" do
    page.should render(%{<r:attachment:each offset="1" by="filename"><r:link/></r:attachment:each>}).as(%{<a href="#{img.public_filename}">rails.png</a>})
  end

  it "should filter attachments by extension" do
    page.should render(%{<r:attachment:each extensions="png"><r:filename/></r:attachment:each>}).as("rails.png")
  end
  it "should filter attachments by multiple extensions" do
    page.should render(%{<r:attachment:each extensions="png|txt"><r:filename/></r:attachment:each>}).as("rails.pngfoo.txt")
  end
  
  it "should render if attachments" do
    page.should render(%{<r:if_attachments>content</r:if_attachments>}).as("content")
  end 
  it "should only render if has the minimum attachments" do
    page.should render(%{<r:if_attachments min_count="3">content</r:if_attachments>}).as("")
  end
  it "should only render if has the minimum attachments with the specified extension" do
    page.should render(%{<r:if_attachments min_count="1" extensions="png">content</r:if_attachments>}).as("content")
  end
  
  it "should render the extension" do
    page.should render(%{<r:attachment:each><r:extension/></r:attachment:each>}).as("pngtxt")
  end
  
  
  it "should render an attachment inherited from the parent" do
    child_page = pages(:first)
    child_page.should render('<r:attachment:url name="rails.png" />').as(img.public_filename)
    child_page.should render('<r:attachment:url name="foo.txt" />').as(txt.public_filename)
  end
  
  private

    def page(symbol = nil)
      if symbol.nil?
        @page ||= pages(:home)
      else
        @page = pages(symbol)
      end
    end
    def img
      page_attachments(:rails_png)
    end
    def txt
      page_attachments(:foo_txt)
    end
  
end
