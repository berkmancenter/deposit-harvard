require 'spec_helper'

describe User do
  before :each do
    @user = User.new(:email => "test@testing.com", :password => "testing")
  end

  it "should have a full name" do
    @user.first_name = "Test"
    @user.last_name = "Ing"
    @user.full_name.should eql "Test Ing"
  end

  it "should only display first name if last name is non-existent" do
    @user.first_name = "Test"
    @user.full_name.should eql "Test"
  end

  it "should display nothing if the name fields haven't been filled in" do
    @user.full_name.should eql ""
  end
end
