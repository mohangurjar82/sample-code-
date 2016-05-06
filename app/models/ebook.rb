class Ebook < ActiveRecord::Base

  mount_uploader :file, FileUploader
  mount_uploader :picture, PictureUploader, mount_on: :image
  
end
