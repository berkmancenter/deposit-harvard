class Deposit < ActiveRecord::Base
  belongs_to :user
  validates :title, :presence => true
  mount_uploader :document, DocumentUploader

  def repositories
    nil
  end
end
