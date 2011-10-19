class Attachment < ActiveRecord::Base
  mount_uploader :file, DocumentUploader
end
