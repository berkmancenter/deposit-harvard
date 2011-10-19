class Attachment < ActiveRecord::Base
  belongs_to :deposit_request
  mount_uploader :file, DocumentUploader
end
