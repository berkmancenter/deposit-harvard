require 'spec_helper'

describe DepositRequestsController do
  login_user

  def mock_deposit_request(stubs={})
    @mock_deposit_request ||= mock_model(DepositRequest, stubs).as_null_object
  end

  describe 'GET index' do
    it "retrieves current user's deposit requests" do
      get :index
      assigns[:deposit_requests].should_not be_nil
    end
  end

  describe 'GET new' do
    before :each do
      @user.first_name = "Test"
      @user.last_name = "Ing"
      @user.save
    end

    it "assigns current user as the default author" do
      get :new
      assigns[:deposit_request].authors.should_not be_empty
    end
  end

  describe 'POST deposit_request' do
    it "creates a new resource" do
      post :create, {:deposit_request => {:title => "Test title", :document => "test_title.doc", :abstract => "Test abstract", :authors => "Imma Author", :document_type => "Thesis"}}
      response.should redirect_to(:action => "index")
    end

    it "fails to submit all information needed" do
      post :create, {:deposit_request => {:document => "test_title.doc"}}
      response.should render_template("new")
    end
  end
end
