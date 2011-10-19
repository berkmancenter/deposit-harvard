class JoinRequestsAndJobs < ActiveRecord::Migration
  def up
    create_table(:deposit_requests_jobs, :id => false) do |t|
      t.integer :deposit_request_id
      t.integer :job_id
    end
  end

  def down
    drop_table :deposit_requests_jobs
  end
end
