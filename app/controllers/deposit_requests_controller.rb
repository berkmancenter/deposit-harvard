class DepositRequestsController < ApplicationController
  def index
    @deposit_requests = current_user.deposit_requests
  end

  def new
    @deposit_request = current_user.deposit_requests.new(:authors => current_user.full_name, :copyright_holder => current_user.full_name, :identifier => "http://harvard.edu")
  end

  def create
    @deposit_request = current_user.deposit_requests.new(params[:deposit_request])

    if @deposit_request.save
      redirect_to deposit_requests_path
    else
      render :action => "new"
    end
  end
end
