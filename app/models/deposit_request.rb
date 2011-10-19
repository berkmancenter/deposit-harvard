class DepositRequest < ActiveRecord::Base
  belongs_to :user
  
  has_many :attachments
  accepts_nested_attributes_for :attachments
  
  has_and_belongs_to_many :jobs, :class_name => "::Delayed::Job"
  
  attr_accessor :repositories
  
  validates :title, :abstract, :authors, :repositories, :presence => true

  after_save :spawn_jobs
  
  def spawn_jobs
    self.repositories.each do |repos|
      self.jobs << Delayed::Job.enqueue(DepositJob.new(self.id, repos.to_sym))
    end
  end
end
