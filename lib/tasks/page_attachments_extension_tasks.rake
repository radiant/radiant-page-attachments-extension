namespace :radiant do
  namespace :extensions do
    namespace :page_attachments do
      
      desc "Runs the migrate and update tasks"
      task :install => [:environment, :migrate, :update]

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
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[PageAttachmentsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(PageAttachmentsExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end
    end
  end
end
