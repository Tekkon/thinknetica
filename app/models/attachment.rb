class Attachment < ApplicationRecord
  belongs_to :attachmentable, optional: true, polymorphic: true

  mount_uploader :file, FileUploader

  def filename
    self.file.identifier
  end
end
