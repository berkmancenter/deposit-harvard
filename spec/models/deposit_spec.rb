require 'spec_helper'

describe Deposit do
  before :each do
    @user = User.create!(:email => 'test@testing.com', :password => 'testing')
    @deposit = @user.deposits.new(:title => 'Bob article')
  end

  describe 'basic validation' do
    it 'should have a user' do
      @deposit.user.should_not be_nil
    end

    it 'should have a title' do
      @deposit.title = nil
      @deposit.should_not be_valid
    end

    it 'should have an abstract' do
      @deposit.abstract = nil
      @deposit.should_not be_valid
    end

    it 'should have a document type' do
      @deposit.document_type = nil
      @deposit.should_not be_valid
    end

    it 'should have authors' do
      @deposit.authors = nil
      @deposit.should_not be_valid
    end

    it 'should have a document' do
      @deposit.document.should_not be_nil
    end
  end
end
