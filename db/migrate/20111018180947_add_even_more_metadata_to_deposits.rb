class AddEvenMoreMetadataToDeposits < ActiveRecord::Migration
  def change
    add_column :deposits, :status_statement, :string
    add_column :deposits, :date_available, :datetime
    add_column :deposits, :language, :string
    add_column :deposits, :identifier, :string
    add_column :deposits, :custodian, :string
    add_column :deposits, :copyright_holder, :string
  end
end
