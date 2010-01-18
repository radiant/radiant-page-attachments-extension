require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^I am logged in as (.*)(?: user)?$/ do |username|
  visit login_path
  fill_in "Username", :with => username
  fill_in "Password",  :with => "password"
  click_button "Login"
end

Given /^I have a page$/ do
  @page = pages(:home)
end

Given /^I have a page with (\d+) attachments$/ do |number|
  Given "I have a page"
  @page.attachments.length.should == number.to_i
end

Given /^I have a page with no attachments$/ do
  @page = pages(:first)
  @page.attachments.should be_empty
end

When /^I edit the page$/ do
  visit edit_admin_page_path(@page)
end

When /^I click the plus icon$/ do
  selenium.click "xpath=id('attachments')//img[@alt='Add']"
end

When /^I attach the Rails logo$/ do
  attach_file "file_input", "#{PageAttachmentsExtension.root}/spec/fixtures/rails.png"
end

When /^I delete the first attachment$/ do
  selenium.click "xpath=id('attachment_list')/li[1]//img[@alt='Delete']"
end

When /^I drag attachment 2 above attachment 1$/ do
  @attachment = @page.attachments[1]
  @attachment.position.should == 2
  selenium.dragdrop("id=attachment_#{@attachment.id}", "0, -200")
end

When /^I save$/ do
  click_button "Save"
  response.should_not contain("errors")
end

Then /^the page should have a new attachment$/ do
  @page.reload.attachments.should_not be_empty
end

Then /^the page should have (\d+) attachment(?:s)?$/ do |number|
  @page.reload.attachments.length.should == number.to_i
end

Then /^attachment 2 should be in position 1$/ do
  @attachment.reload.position.should == 1
end
