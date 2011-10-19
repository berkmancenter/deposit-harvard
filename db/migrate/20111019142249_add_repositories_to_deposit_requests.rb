class AddRepositoriesToDepositRequests < ActiveRecord::Migration
  def change
    add_column :deposit_requests, :repositories, :text
  end
end
