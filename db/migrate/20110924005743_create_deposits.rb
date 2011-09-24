class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.string :title, :limit => 500
      t.string :document
      t.integer :user_id
      t.timestamps
    end
  end
end
