module PageAttachmentTags
  include Radiant::Taggable

  class TagError < StandardError; end
  
  desc %{
    The namespace for referencing page attachments/files.  You may specify the 'name'
    attribute (for the filename) on this tag for all contained tags to refer to that attachment.  
    Attachments can be inherited from parent pages.
    
    *Usage*:
    
    <pre><code><r:attachment name="file.txt">...</r:attachment></code></pre>
  }
  tag "attachment" do |tag|
    page = tag.locals.page
    tag.locals.attachment = page.attachment(tag.attr['name']) rescue nil if tag.attr['name']
    tag.expand
  end
  
  desc %{
    Renders the url or public filename of the attachment for use in links, stylesheets, etc.
    The 'name' attribute is required on this tag or the parent tag.  The optional 'size' attribute
    applies only to images.
    
    *Usage*:
    
    <pre><code><r:attachment:url name="file.jpg" [size="icon"]/></code></pre>
  }
  tag "attachment:url" do |tag|
    raise TagError, "'name' attribute required" unless name = tag.attr['name'] or tag.locals.attachment
    page = tag.locals.page
    size = tag.attr['size'] || nil
    attachment = tag.locals.attachment || page.attachment(name)
    attachment.public_filename(size)
  end
  
  [:content_type, :size, :width, :height, :title].each do |key|
    desc %{
      Renders the `#{key}' attribute of the attachment.     
      The 'name' attribute is required on this tag or the parent tag.  The optional 'size'
      attributes applies only to images.
      
    *Usage*:
    
    <pre><code><r:attachment:#{key} name="file.jpg" [size="icon"]/></code></pre>
    }
    tag "attachment:#{key}" do |tag|
      raise TagError, "'name' attribute required" unless name = tag.attr['name'] or tag.locals.attachment
      page = tag.locals.page
      attachment = tag.locals.attachment || page.attachment(name)
      attachment.attributes["#{key}"]
    end
  end
  
  desc %{
    Renders the date the attachment was uploaded using the specified `format' (Ruby's strftime syntax).
    The 'name' attribute is required on this tag or the parent tag.
    
    *Usage*:
    
    <pre><code><r:attachment:date name="file.jpg"/></code></pre>
  }
  tag "attachment:date" do |tag|
    raise TagError, "'name' attribute required" unless name = tag.attr['name'] or tag.locals.attachment
    page = tag.locals.page
    attachment = tag.locals.attachment || page.attachment(name)
    format = tag.attr['format'] || "%F"  
    attachment.created_at.strftime(format)
  end
  
  desc %{
    Renders an image tag for the attachment (assuming it's an image).
    The 'name' attribute is required on this tag or the parent tag.
    Any other attributes will be added as HTML attributes to the rendered tag.
    The optional 'size' attribute allows you to show the icon size of the image.

    *Usage*:
    
    <pre><code><r:attachment:image name="file.jpg" [size="icon"]/></code></pre>

    }
  tag "attachment:image" do |tag|
    raise TagError, "'name' attribute required" unless name = tag.attr.delete('name') or tag.locals.attachment
    page = tag.locals.page
    attachment = tag.locals.attachment || page.attachment(name)
    size = tag.attr['size'] || nil
    raise TagError, "attachment is not an image." unless attachment.content_type.strip =~ /^image\//
    filename = attachment.public_filename(size) rescue ""
    attributes = tag.attr.inject([]){ |a,(k,v)| a << %{#{k}="#{v}"} }.join(" ").strip
    %{<img src="#{filename}" #{attributes + " " unless attributes.empty?}/>}
  end
  
  desc %{
    Renders a hyperlink to the attachment. The 'name' attribute is required on this tag or the parent tag.
    You can use the 'label' attribute to specify the textual contents of the tag.  Any other attributes 
    will be added as HTML attributes to the rendered tag.  This tag works as both a singleton and a container.
    Any contained content will be rendered inside the resulting link.  The optional 'size' attribute applies only to images.

    *Usage*:
    
    <pre><code><r:attachment:link name="file.jpg" [size="thumbnail"]/></code></pre>
    <pre><code><r:attachment:link name="file.jpg" [size="thumbnail"]> Some text in the link </r:attachment:link></code></pre>
  }
  tag "attachment:link" do |tag|
    raise TagError, "'name' attribute required" unless name = tag.attr.delete('name') or tag.locals.attachment
    page = tag.locals.page
    attachment = tag.locals.attachment || page.attachment(name)
    label = tag.attr.delete('label') || attachment.filename
    size = tag.attr.delete('size') || nil
    filename = attachment.public_filename(size) rescue ""
    attributes = tag.attr.inject([]){ |a,(k,v)| a << %{#{k}="#{v}"} }.join(" ").strip
    output = %{<a href="#{filename}"#{" " + attributes unless attributes.empty?}>}
    output << (tag.double? ? tag.expand : label)
    output << "</a>"
  end
  
  desc %{
    Renders the name of who uploaded the attachment. The 'name' attribute is required on this tag or the parent tag.
    
    *Usage*:
    
    <pre><code><r:attachment:author name="file.jpg" /></code></pre>
  }
  tag "attachment:author" do |tag|
    raise TagError, "'name' attribute required" unless name = tag.attr.delete('name') or tag.locals.attachment
    page = tag.locals.page
    attachment = tag.locals.attachment || page.attachment(name) 
    if attachment and author = attachment.created_by
      author.name
    end
  end
  
  desc %{
    Iterates through all the attachments in the current page.  The 'name' attribute is not required
    on any nested attachment tags.
    
    *Usage*:
    
    <pre><code><r:attachment:each [order="asc|desc"] [by="filename|size|created_at|..."] [limit=0] [offset=0]>
        <r:link /> - <r:date>
    </r:attachment:each></code></pre>
  }
  tag "attachment:each" do |tag|
    page = tag.locals.page
  	order = tag.attr["order"] || "asc"
    by = tag.attr["by"] || "id"
    limit = tag.attr["limit"] || nil
    offset = tag.attr["offset"] || nil
    returning String.new do |output|
      page.attachments.find(:all, :order => [by, order].join(" "), :limit => limit, :offset => offset).each do |att|
        tag.locals.attachment = att
        output << tag.expand
      end
    end
  end  
end
