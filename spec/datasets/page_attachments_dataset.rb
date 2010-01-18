class PageAttachmentsDataset < Dataset::Base
  uses :pages, :users
  
  def load
    create_page_attachment "rails.png", :title => "Rails logo", :content_type => "image/png", :width => 50, :height => 64, :description => "The awesome Rails logo."
    create_page_attachment "foo.txt", :title => "Simple text file", :content_type => "text/plain", :description => "Nice shootin', text."
  end
  
  helpers do
    def create_page_attachment(filename, attributes={})
      create_record :page_attachment, filename.symbolize, page_attachment_params(attributes.reverse_merge(:filename => filename))
    end
    
    def page_attachment_params(attributes={})
      page = pages(:home)
      { 
        :size => File.join(File.dirname(__FILE__), '/../fixtures/', attributes[:filename]).size,
        :page => page,
        :position => next_position(page),
        :created_by => users(:admin)
      }.merge(attributes)
    end
    
    private
      
      def next_position(page)
        (page.attachments.maximum(:position) || 0) + 1
      end
  end
  
end