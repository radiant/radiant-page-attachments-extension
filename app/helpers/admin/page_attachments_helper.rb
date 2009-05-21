module Admin::PageAttachmentsHelper
  def preview_path(attachment)
    case attachment.filename
    when /pdf$/
      attachment_path = '/images/admin/page_attachments/pdf-icon.png'
    else
      attachment_path = attachment.public_filename
    end
    attachment_path
  end
end