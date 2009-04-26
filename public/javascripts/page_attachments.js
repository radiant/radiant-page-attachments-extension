document.observe("dom:loaded", function() {
  when('attachments', function(container) {
    var upload = '<div class="attachment-upload"><p class="title">Upload file</p><table><tr><th><label for="title_input">Title:</label></th><td><input id="title_input" size="60" name="page[add_attachments][title][]"></td></tr><tr><th><label for="description_input">Description:</label></th><td><input id="description_input" type="text" size="60"  name="page[add_attachments][description][]"></td></tr><tr><th><label for="file_input">File:</label></th><td><input id="file_input" type="file" size="60" name="page[add_attachments][file][]" /><img src="/images/admin/minus.png" alt="cancel" /></td></tr></table></div>'
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
          new Ajax.Updater('attachment_list','/page_attachments/destroy/', {method:'post', parameters:{id: id, authenticity_token: auth_token}})
                  var attach_count = $('attachment_count')
                  attach_count.update(parseInt(attach_count.innerHTML) - 1)
        }
      } else if(target.match('img.higher')) {
        var attachment = e.findElement('.attachment')
        var id = attachment.id.split('_').last()
        new Ajax.Updater('attachment_list','/page_attachments/move_higher/', {method:'post', parameters:{id: id, authenticity_token: auth_token}})
          } else if(target.match('img.lower')) {
        var attachment = e.findElement('.attachment')
        var id = attachment.id.split('_').last()
        new Ajax.Updater('attachment_list','/page_attachments/move_lower/', {method:'post', parameters:{id: id, authenticity_token: auth_token}})
          }
    })
  })
})
