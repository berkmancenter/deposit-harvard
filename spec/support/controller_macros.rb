module ControllerMacros
  def login_user
    before(:each) do
      @user = User.create!(:email => "test@testing.com", :password => "testing")
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
    end
  end
end
