require 'spec_helper'

describe DepositRequest do
  before :each do
    @user = User.create!(:email => 'test@testing.com', :password => 'testing')
    @deposit_request = @user.deposit_requests.new(:title => 'Bob article', :repositories => [:test_repo])
  end

  describe 'basic validation' do
    it 'should have a user' do
      @deposit_request.user.should_not be_nil
    end

    it 'should have a title' do
      @deposit_request.title = nil
      @deposit_request.should_not be_valid
      @deposit_request.errors.messages.keys.should include :title
    end

    it 'should have an abstract' do
      @deposit_request.abstract = nil
      @deposit_request.should_not be_valid
      @deposit_request.errors.messages.keys.should include :abstract
    end

    it 'should have authors' do
      @deposit_request.authors = nil
      @deposit_request.should_not be_valid
      @deposit_request.errors.messages.keys.should include :authors
    end

    it 'should have repositories' do
      @deposit_request.repositories = nil
      @deposit_request.should_not be_valid
      @deposit_request.errors.messages.keys.should include :repositories
    end
  end

  describe 'spawn DepositJobs after create' do
    it 'should spawn at least one deposit job after creation' do
      @deposit_request.abstract = "Yo, abstraction over compaction"
      @deposit_request.authors = "Quaid, Dennis"
      @deposit_request.should be_valid
      @deposit_request.save
      @deposit_request.jobs.count.should_not == 0
    end
  end
end

