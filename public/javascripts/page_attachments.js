document.observe("dom:loaded", function() {
  when('attachments', function(container) {
    var upload = '<div class="attachment-upload"><label>Upload file: <input type="file" name="page[add_attachments][]" /></label> <img src="/images/admin/minus.png" alt="cancel" /></div>'
    var deletion = new Template('<input type="hidden" name="page[delete_attachments][]" value="#{id}" />')
    var notice = '<p class="notice">Removed attachments will be deleted when you save this page.</p>'
    
    container.observe('click', function(e) {
      var target = $(e.target)
      
      if (target.match('img[alt=Add]')) {
        container.insert(upload)
      }
      else if (target.match('img[alt=cancel]')) {
        e.findElement('.attachment-upload').remove()
        e.stop()
      }
      else if (target.match('img.delete')) {
        if (confirm("Really delete this attachment?")) {
          var attachment = e.findElement('.attachment')
          var id = attachment.id.split('_').last()
          attachment.remove()
          if (!container.down('p.notice')) container.insert(notice)
          container.insert(deletion.evaluate({ id: id }))
        }
      }
    })
  })
})
