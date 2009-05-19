require_dependency 'application'
# require File.dirname(__FILE__) + '/lib/geometry'
# require 'tempfile'

class PageAttachmentsExtension < Radiant::Extension
  version "0.3"
  description "Adds page-attachment-style asset management."
  url "http://radiantcms.org"

   define_routes do |map|
     map.namespace :admin do |admin|
       admin.page_attachments '/page_attachments', :controller => 'page_attachments'
     end
    
     map.connect 'page_attachments/:action/:id', :controller => 'page_attachments'
   end

  def activate
    require 'will_paginate'
    admin.tabs.add "Attachments", "/admin/page_attachments", :after => "Layouts", :visibility => [:admin]
    # Regular page attachments stuff
    Page.class_eval {
      include PageAttachmentAssociations
      include PageAttachmentTags
    }
    UserActionObserver.send :include, ObservePageAttachments
    Admin::PagesController.send :include, PageAttachmentsInterface
  end

  def deactivate
  end

end
