document.observe("dom:loaded", function() {
  when('attachments', function(container) {
    var upload = '<div class="attachment-upload"><label>Upload file: <br/>Title: <input type="text" size="40" name="page[add_attachments][title][]"><br/>Description: <input type="text" size="60" name="page[add_attachments][description][]"><br/>File: <input type="file" name="page[add_attachments][file][]" /></label> <img src="/images/admin/minus.png" alt="cancel" /></div>'
    
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
        if (confirm("Really delete this attachment? This will take effect immediately.")) {
          var attachment = e.findElement('.attachment')
          var id = attachment.id.split('_').last()
          new Ajax.Updater('attachment_list','/page_attachments/destroy/', {method:'post', parameters:'id=' + id})
		  var attach_count = $('attachment_count')
		  attach_count.update(parseInt(attach_count.innerHTML) - 1) 
        }
      } else if(target.match('img.higher')) {
        var attachment = e.findElement('.attachment')
        var id = attachment.id.split('_').last()
        new Ajax.Updater('attachment_list','/page_attachments/move_higher/', {method:'post', parameters:'id=' + id})
	  } else if(target.match('img.lower')) {
        var attachment = e.findElement('.attachment')
        var id = attachment.id.split('_').last()
        new Ajax.Updater('attachment_list','/page_attachments/move_lower/', {method:'post', parameters:'id=' + id})
	  }
    })
  })
})
