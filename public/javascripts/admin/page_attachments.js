document.observe("dom:loaded", function() {
  when('attachments', function(container) {
    var upload = '<div class="attachment-upload"><p class="title">Upload file</p><table><tr><th><label for="title_input">Title:</label></th><td><input id="title_input" size="60" name="page[attachments_attributes][][title]"></td></tr><tr><th><label for="description_input">Description:</label></th><td><input id="description_input" type="text" size="60"  name="page[attachments_attributes][][description]"></td></tr><tr><th><label for="file_input">File:</label></th><td><input id="file_input" type="file" size="60" name="page[attachments_attributes][][uploaded_data]" /><img src="/images/admin/minus.png" alt="cancel" /></td></tr></table></div>'
    function updatePositions(container) {
      container.select(".attachment").each( function(e,i){
        e.down('input[name*="position"]').setValue(i+1);
      });
    }
    when('attachment_list', function(container) {
      Sortable.create('attachment_list', {onUpdate:updatePositions});
    });
    container.observe('click', function(e) {
      var target = $(e.target)

      if (target.match('img[alt=Add]')) {
        $('attachment-index-field').value = parseInt($('attachment-index-field').value) + 1;
        container.insert(upload.gsub(/\[\]/,'['+$('attachment-index-field').value+']'))
      }
      else if (target.match('img[alt=cancel]')) {
        e.findElement('.attachment-upload').remove()
        e.stop()
      }
      else if (target.match('img.delete')) {
        var attachment = e.findElement('.attachment');
        attachment.addClassName('deleted');
        attachment.insert("<em>Attachment will be deleted when page is saved.</em>");
        attachment.down('input[name*="_delete"]').setValue('true');
      }
    })
  })
})
