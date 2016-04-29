class Medium < ActiveRecord::Base
  validates :title, :source_url, presence: true

  has_many :media_categories
  has_many :categories, through: :media_categories

  mount_uploader :picture, PictureUploader, mount_on: :image
end
# alias
class Media < Medium; ;end
