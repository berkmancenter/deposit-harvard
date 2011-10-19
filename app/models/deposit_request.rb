class DepositRequest < ActiveRecord::Base
  belongs_to :user
  has_many :attachments
  
  validates :title, :abstract, :authors, :presence => true

  def repositories
    nil
  end
end
