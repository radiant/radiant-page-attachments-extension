require_dependency 'application'
# require File.dirname(__FILE__) + '/lib/geometry'
# require 'tempfile'

class PageAttachmentsExtension < Radiant::Extension
  version "0.3"
  description "Adds page-attachment-style asset management."
  url "http://radiantcms.org"

  def activate
    # Regular page attachments stuff
    Page.class_eval {
      include PageAttachmentAssociations
      include PageAttachmentTags
    }
    UserActionObserver.send :include, ObservePageAttachments
    Admin::PageController.send :include, PageAttachmentsInterface
  end

  def deactivate
  end

end
