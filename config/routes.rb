ActionController::Routing::Routes.draw do |map|
  
  map.namespace :admin do |admin|
    admin.resources :page_attachments
    admin.page_attachments_grid '/page_attachments_grid', :controller => 'page_attachments', :action => 'grid'
  end
  
end