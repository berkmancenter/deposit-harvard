class AddAdditionalFieldsToDeposit < ActiveRecord::Migration
  def change
    add_column :deposits, :abstract, :string, :limit => 1000
    add_column :deposits, :document_type, :string, :limit => 100
    add_column :deposits, :authors, :string, :limit => 512
  end
end
