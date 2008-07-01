require_dependency 'application'
unless Object.const_defined?(:Geometry)
	require File.dirname(__FILE__) + '/lib/geometry'
end
require 'tempfile'

class PageAttachmentsExtension < Radiant::Extension
  version "0.2"
  description "Adds page-attachment-style asset management."
  url "http://seancribbs.com"

   define_routes do |map|
     map.connect 'page_attachments/:action/:id', :controller => 'page_attachments'
   end
  
  def activate
    # Contents of attachment_fu/init.rb
    
    Tempfile.class_eval do
      # overwrite so tempfiles use the extension of the basename.  important for rmagick and image science
      def make_tmpname(basename, n)
        ext = nil
        sprintf("%s%d-%d%s", basename.to_s.gsub(/\.\w+$/) { |s| ext = s; '' }, $$, n, ext)
      end
    end
    
    ActiveRecord::Base.send(:extend, Technoweenie::AttachmentFu::ActMethods)
    Technoweenie::AttachmentFu.tempfile_path = ATTACHMENT_FU_TEMPFILE_PATH if Object.const_defined?(:ATTACHMENT_FU_TEMPFILE_PATH)
    FileUtils.mkdir_p Technoweenie::AttachmentFu.tempfile_path

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
