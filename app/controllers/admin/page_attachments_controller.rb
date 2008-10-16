class Admin::PageAttachmentsController < ApplicationController
  
  def index
    @attachments = PageAttachment.paginate :per_page => 25, :page => params[:page], :conditions => {:parent_id => nil}
  end
  
	def move_higher
		if request.post?
			@attachment = PageAttachment.find(params[:id])
			@attachment.move_higher
			render :partial => 'admin/page/attachment', :layout => false, :collection => @attachment.page.attachments
		end
	end

	def move_lower
		if request.post?
			@attachment = PageAttachment.find(params[:id])
			@attachment.move_lower
			render :partial => 'admin/page/attachment', :layout => false, :collection => @attachment.page.attachments
		end
	end
	
	def destroy
		if request.post?
			@attachment = PageAttachment.find(params[:id])
			page = @attachment.page
			@attachment.destroy
			render :partial => 'admin/page/attachment', :layout => false, :collection => page.attachments
		end
	end
end