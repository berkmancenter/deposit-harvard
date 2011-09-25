class Deposit < ActiveRecord::Base
  belongs_to :user
  validates :title, :abstract, :authors, :document_type, :presence => true
  mount_uploader :document, DocumentUploader

  def repositories
    nil
  end
end
