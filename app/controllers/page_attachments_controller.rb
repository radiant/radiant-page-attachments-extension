class PageAttachmentsController < ApplicationController
  def move_higher
    if request.post?
      @attachment = PageAttachment.find(params[:id])
      @attachment.move_higher
      render :partial => 'admin/pages/attachment',
             :layout => false,
             :collection => @attachment.page.attachments
    end
  end

  def move_lower
    if request.post?
      @attachment = PageAttachment.find(params[:id])
      @attachment.move_lower
      render :partial => 'admin/pages/attachment',
             :layout => false,
             :collection => @attachment.page.attachments
    end
  end

  def destroy
    if request.post?
      @attachment = PageAttachment.find(params[:id])
      page = @attachment.page
      @attachment.destroy
      render :partial => 'admin/pages/attachment',
             :layout => false,
             :collection => page.attachments
    end
  end
end
