require 'spec_helper'

describe DepositRequest do
  before :each do
    @user = User.create!(:email => 'test@testing.com', :password => 'testing')
    @deposit_request = @user.deposit_requests.new(:title => 'Bob article')
  end

  describe 'basic validation' do
    it 'should have a user' do
      @deposit_request.user.should_not be_nil
    end

    it 'should have a title' do
      @deposit_request.title = nil
      @deposit_request.should_not be_valid
    end

    it 'should have an abstract' do
      @deposit_request.abstract = nil
      @deposit_request.should_not be_valid
    end

    it 'should have a document type' do
      @deposit_request.document_type = nil
      @deposit_request.should_not be_valid
    end

    it 'should have authors' do
      @deposit_request.authors = nil
      @deposit_request.should_not be_valid
    end

    it 'should have a document' do
      @deposit_request.document.should_not be_nil
    end
  end
end

