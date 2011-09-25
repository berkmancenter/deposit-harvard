class DepositsController < ApplicationController
  def index
    @deposits = current_user.deposits
  end

  def new
    @deposit = current_user.deposits.new(:authors => current_user.full_name)
  end

  def create
    @deposit = current_user.deposits.new(params[:deposit])
    if @deposit.save
      redirect_to deposits_path
    else
      render :action => "new"
    end
  end
end
