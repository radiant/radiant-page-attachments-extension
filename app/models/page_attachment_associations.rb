module PageAttachmentAssociations
  def self.included(base)
    base.class_eval {
      has_many :attachments,
               :class_name => "PageAttachment",
               :dependent => :destroy,
               :order => 'position'
      include InstanceMethods
      accepts_nested_attributes_for :attachments, :allow_destroy => true
    }
  end

  module InstanceMethods
    # Currently recursive, but could be simplified with some SQL
    def attachment(name)
      att = attachments.find(:first, :conditions => ["filename LIKE ?", name.to_s])
      att.blank? ? ((parent.attachment(name) if parent) or nil) : att
    end
  end
end
