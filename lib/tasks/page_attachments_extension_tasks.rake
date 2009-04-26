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

      desc "Installs files relevant to Page Attachments into public/"
      task :update => :environment do
        FileUtils.cp PageAttachmentsExtension.root + "/public/stylesheets/page_attachments.css", RAILS_ROOT + "/public/stylesheets/admin"
        FileUtils.cp PageAttachmentsExtension.root + "/public/javascripts/page_attachments.js", RAILS_ROOT + "/public/javascripts"
        FileUtils.cp PageAttachmentsExtension.root + "/public/images/admin/move_higher.png", RAILS_ROOT + "/public/images/admin"
        FileUtils.cp PageAttachmentsExtension.root + "/public/images/admin/move_lower.png", RAILS_ROOT + "/public/images/admin"
      end
    end
  end
end
