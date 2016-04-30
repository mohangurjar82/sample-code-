class Medium < ActiveRecord::Base
  validates :title, presence: true

  has_many :media_categories, dependent: :destroy
  has_many :categories, through: :media_categories

  mount_uploader :picture, PictureUploader, mount_on: :image
end
# alias
class Media < Medium; ;end
