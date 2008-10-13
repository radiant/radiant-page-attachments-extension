module PageAttachmentAssociations
  def self.included(base)
    base.class_eval {
      has_many :attachments, :class_name => "PageAttachment", :dependent => :destroy, :order => 'position' do
        def by_extensions(extensions, options={})
          conditions = unless extensions.blank?
            [ extensions.map { |ext| "page_attachments.filename LIKE ?"}.join(' OR '), 
              *extensions.map { |ext| "%#{ext}" } ]
          else
            nil
          end
          find(:all, options.merge(:conditions => conditions))
        end
      end
  
      attr_accessor :add_attachments
      after_save :save_attachments
      include InstanceMethods
    }
  end
  
  module InstanceMethods     
    # Currently recursive, but could be simplified with some SQL
    def attachment(name)
      att = attachments.find(:first, :conditions => ["filename LIKE ?", name.to_s])
      att.blank? ? ((parent.attachment(name) if parent) or nil) : att
    end

    def save_attachments
      if @add_attachments && ! @add_attachments['file'].blank?
		i = 0
        @add_attachments['file'].each do |page_attach|
          attachments << PageAttachment.new(
			  :uploaded_data => page_attach, 
			  :title => @add_attachments['title'][i],
			  :description => @add_attachments['description'][i]
		  )
		  i += 1
        end  
      end
      @add_attachments = nil
    end  
  end
end
