Page Attachments
===

About
---

A [Radiant][rd] Extension by [Sean Cribbs][sc] that adds page-attachment-style asset management.

Installation
---

If you want `page_attachments` to generate and display thumbnails of your uploaded images you'll first need to install one of, [`image_science`][is], [`mini-magick`][mm] or [`rmagick`][rm] on your server. This is completely optional, `page_attachments` will still function in every other way without any of these packages installed.

Next, you need to install the `attachment_fu` plugin.

    `cd /path/to/radiant`
    `git clone git://github.com/technoweenie/attachment_fu.git vendor/plugins/attachment_fu`

If you don't have `git` installed you can simply [download a tarball][af] of `attachment_fu`, upload and unpack it to your `vendor/plugins` directory.

**Failing to install the `attachment_fu` plugin before proceeding will result in an "`uninitialized constant Technoweenie::AttachmentFu`" error when you try to install `page_attachments`.**

Now you're ready to install `page_attachments`.

  `cd /path/to/radiant`
  `git clone git://github.com/radiant/radiant-page-attachments-extension.git vendor/extensions/page_attachments`
  `rake radiant:extensions:page_attachments:migrate`
  `rake radiant:extensions:page_attachments:update`

If you don't have `git` you can [download a tarball][pa].

During the `migrate` task you may encounter an "`uninitialized constant Technoweenie::AttachmentFu::Backends`". If this happens try `git clone git://github.com/technoweenie/attachment_fu.git vendor/extensions/page_attachments/vendor/plugins/attachment_fu` and re-run the `migrate` task.

Restart your server and refresh the admin interface.

Managing Attachments
---

Now when you login and edit a page, you'll find the "Attachments" interface below the text editing area. To add a new attachment to the page click the **+** icon. If you need to you can upload multiple attachments at once by clicking the **+** icon once for each attachment you'll be adding. Attachments are **not** added or deleted until the page is saved. Therefore, if you accidentally deleted something you meant to keep, simply cancel the page edit.

Usage
---

* Reference an attachment by name `<r:attachment name="file.txt">...</r:attachment>`
* Display an attachment's URL `<r:attachment:url name="file.jpg"/>`
* Display an attachment's `#{key}` attribute `<r:attachment:#{key} name="file.jpg"/>`
* Display the date an attachment was added `<r:attachment:date name="file.txt"/>`
* Display an attached image `<r:attachment:image name="file.jpg"/>`
* Display a link to an attachment `<r:attachment:link name="file.jpg"/>` or `<r:attachment:link name="file.jpg">Click Here</r:attachment:link>`
* Display name of the user who added the attachment `<r:attachment:author name="file.jpg"/>`
* Iterate through all the attachments on a page `<r:attachment:each><r:link/></r:attachment:each>`

Troubleshooting
---

If you have a problem running the migrate task, and it fails with an error something like this:

    ld: library not found for -lfreeimage
    collect2: ld returned 1 exit status

It means you have installed the ImageScience gem but you don't have FreeImage installed. So, either install FreeImage or uninstall the gem with

    gem uninstall image_science

---

If you're using ImageScience as a user without a home directory, you may see this error:

    Define INLINEDIR or HOME in your environment and try again

This is caused by RubyInline not having a place to store its generated files and can be easily fixed by specifying a path in your environment file like so:

    ENV['INLINEDIR'] = File.join(RAILS_ROOT,'tmp','ruby_inline')

[rd]: http://radiantcms.org/
[sc]: http://seancribbs.com/
[is]: http://seattlerb.rubyforge.org/ImageScience.html
[mm]: http://rubyforge.org/projects/mini-magick/
[rm]: http://rmagick.rubyforge.org/
[af]: http://github.com/technoweenie/attachment_fu/tree/master
[pa]: http://github.com/radiant/radiant-page-attachments-extension/tarball/master