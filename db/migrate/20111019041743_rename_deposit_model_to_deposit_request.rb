class RenameDepositModelToDepositRequest < ActiveRecord::Migration
  def change
    rename_table :deposits, :deposit_requests
  end
end
