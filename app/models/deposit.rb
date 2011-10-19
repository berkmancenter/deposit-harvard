class Deposit < ActiveRecord::Base
  belongs_to :user
  has_many :attachments
  
  validates :title, :abstract, :authors, :document_type, :presence => true

  def repositories
    nil
  end
end
