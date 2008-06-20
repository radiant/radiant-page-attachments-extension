class PageAttachment < ActiveRecord::Base
  has_attachment :storage => :file_system, 
                     :thumbnails => {:icon => '50x50>'},
                     :max_size => 10.megabytes
  validates_as_attachment
    
  belongs_to :created_by, :class_name => 'User', 
               :foreign_key => 'created_by'
  belongs_to :updated_by, :class_name => 'User',
               :foreign_key => 'updated_by'
               
  belongs_to :page
end