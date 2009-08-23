# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../../../../config/environment')

require 'cucumber/rails/world'
require 'cucumber/formatter/unicode' # Comment out this line if you don't want Cucumber Unicode support
require 'webrat'
raise "Update the version of Webrat you specify in test.rb." if Webrat.const_defined?(:VERSION) && Webrat::VERSION < '0.5.1' # Webrat 0.4.4 won't work with selenium-client 1.2.16

Webrat.configure do |config|
  config.mode = :selenium
  config.selenium_browser_key = "*chrome"
end

# this is necessary to have webrat "wait_for" the response body to be available
# when writing steps that match against the response body returned by selenium
World(Webrat::Selenium::Matchers)

# Patch in attach_file functionality
module Webrat
  class SeleniumSession
    def attach_file(field_locator, path, content_type = nil)
      fill_in(field_locator, :with => path)
    end
  end
end

require 'cucumber/rails/rspec'
require 'dataset'

module Dataset
  module Extensions # :nodoc:
    # Selenium can't handle transactions, so we have to disable them in Dataset
    module CucumberWorldNoTransactions # :nodoc:
      def dataset(*datasets, &block)
        add_dataset(*datasets, &block)

        load = nil
        $__cucumber_toplevel.Before do
          Dataset::Database::Base.new.clear # Empty all tables
          dataset_session.instance_variable_set("@load_stack", []) # notify load_stack that nothing's loaded
          load = dataset_session.load_datasets_for(self.class)
          extend_from_dataset_load(load)
        end
      end
    end
  end
end
 
Cucumber::Rails::World.class_eval do
  include Dataset
  self.extend Dataset::Extensions::CucumberWorldNoTransactions
  datasets_directory "#{RADIANT_ROOT}/spec/datasets"
  Dataset::Resolver.default << (File.dirname(__FILE__) + "/../../spec/datasets")
  self.datasets_database_dump_path = "#{Rails.root}/tmp/dataset"
  dataset :pages_with_layouts, :users, :page_attachments
end