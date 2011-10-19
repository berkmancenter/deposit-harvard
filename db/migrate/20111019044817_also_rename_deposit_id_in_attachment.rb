class AlsoRenameDepositIdInAttachment < ActiveRecord::Migration
  def change
    rename_column :attachments, :deposit_id, :deposit_request_id
  end
end
