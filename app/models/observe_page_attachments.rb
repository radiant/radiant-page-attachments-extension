module ObservePageAttachments
  def self.included(base)
    base.send :observe, User, Page, Layout, Snippet, PageAttachment
  end
end
