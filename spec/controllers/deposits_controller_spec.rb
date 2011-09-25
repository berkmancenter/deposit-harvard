require 'spec_helper'

describe DepositsController do
  login_user

  def mock_deposit(stubs={})
    @mock_deposit ||= mock_model(Deposit, stubs).as_null_object
  end

  describe 'GET index' do
    it "retrieves current user's deposits" do
      get :index
      assigns[:deposits].should_not be_nil
    end
  end

  describe 'POST deposit' do
    it "creates a new resource" do
      post :create, {:deposit => {:title => "Test title", :document => "test_title.doc", :abstract => "Test abstract", :authors => "Imma Author", :document_type => "Thesis"}}
      response.should redirect_to(:action => "index")
    end

    it "fails to submit all information needed" do
      post :create, {:deposit => {:document => "test_title.doc"}}
      response.should render_template("new")
    end
  end
end
