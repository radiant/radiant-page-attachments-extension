require File.dirname(__FILE__) + '/../spec_helper'

describe UserActionObserver do
  
  it "should include ObservePageAttachments" do
    UserActionObserver.included_modules.should include(ObservePageAttachments)
  end
  
  it "should include the observed_class method" do
    UserActionObserver.methods.should include('observed_class')
  end
  
end

