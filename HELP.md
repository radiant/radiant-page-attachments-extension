Managing Attachments
---

When you login and edit a page, you'll find the "Attachments" interface below the 
text editing area. To add a new attachment to the page click the **+** icon. If you 
need to you can upload multiple attachments at once by clicking the **+** icon once 
for each attachment you'll be adding. Attachments are **not** added or deleted until 
the page is saved. Therefore, if you accidentally deleted something you meant to 
keep, simply cancel the page edit.

You'll also find a list of all page attachments under the [Attachments](/admin/page_attachments) tab. There
you'll be able to find a link to each attachment, a link to it's associated page, and
some sample code for displaying the attachment.

Usage
---

* See the "available tags" documentation built into the Radiant page admin for more details.
* Reference an attachment by name `<r:attachment name="file.txt">...</r:attachment>`
* Display an attachment's URL `<r:attachment:url name="file.jpg"/>`
* Display an attachment's `#{key}` attribute `<r:attachment:#{key} name="file.jpg"/>`
* Display the date an attachment was added `<r:attachment:date name="file.txt"/>`
* Display an attached image `<r:attachment:image name="file.jpg"/>`
* Display a link to an attachment `<r:attachment:link name="file.jpg"/>` or `<r:attachment:link name="file.jpg">Click Here</r:attachment:link>`
* Display name of the user who added the attachment `<r:attachment:author name="file.jpg"/>`
* Iterate through all the attachments on a page `<r:attachment:each><r:link/></r:attachment:each>`
* Display the extension of an attachement inside iterations with `<r:attachment:extension/>`