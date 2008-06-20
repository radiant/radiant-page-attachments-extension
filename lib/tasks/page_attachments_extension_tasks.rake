namespace :radiant do
  namespace :extensions do
    namespace :page_attachments do
      
      desc "Runs the migration of the Page Attachments extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          PageAttachmentsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          PageAttachmentsExtension.migrator.migrate
        end
      end
    
      task :update => :environment do
        FileUtils.cp PageAttachmentsExtension.root + "/public/stylesheets/page_attachments.css", RAILS_ROOT + "/public/stylesheets/admin"
        FileUtils.cp PageAttachmentsExtension.root + "/public/javascripts/page_attachments.js", RAILS_ROOT + "/public/javascripts"
      end
    end
  end
end
