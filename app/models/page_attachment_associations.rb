module PageAttachmentAssociations
  def self.included(base)
    base.class_eval {
      has_many :attachments, :class_name => "PageAttachment", :dependent => :destroy
  
      attr_accessor :add_attachments
      attr_accessor :delete_attachments
      after_save :save_attachments
      after_save :destroy_attachments
      include InstanceMethods
    }
  end
  
  module InstanceMethods     
    # Currently recursive, but could be simplified with some SQL
    def attachment(name)
      att = attachments.find(:first, :conditions => ["filename LIKE ?", name.to_s])
      att.blank? ? ((parent.attachment(name) if parent) or nil) : att
    end

    def destroy_attachments
      if @delete_attachments
        @delete_attachments.each do |attachment_id|
          PageAttachment.destroy(attachment_id)
        end
      end
      @delete_attachments = nil
    end
      
    def save_attachments
      if @add_attachments
        @add_attachments.each do |attachment|
          attachments << PageAttachment.new(:uploaded_data => attachment)
        end  
      end
      @add_attachments = nil
    end  
  end
end