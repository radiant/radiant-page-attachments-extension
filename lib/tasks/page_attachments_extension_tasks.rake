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

      desc "Copies public assets of the Page Attachments to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
<<<<<<< HEAD
        Dir[PageAttachmentsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(PageAttachmentsExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
=======
        puts "Copying assets from PageAttachmentsExtension"
        Dir[PageAttachmentsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(PageAttachmentsExtension.root, '')
          directory = File.dirname(path)
>>>>>>> 6051774d4fdf199d7154739d7d7d8ffbc9d1ecfa
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end
    end
  end
end
