class Medium < ActiveRecord::Base
  validates :title, presence: true

  has_many :media_categories, dependent: :destroy
  has_many :categories, through: :media_categories

  mount_uploader :picture, PictureUploader, mount_on: :image

  # mpx compatibility
  def thumbnail_url
    picture.present? ? picture_url : image_url
  end

  def file_url
    source_url
  end

  def category_name
    categories.first.try(:title) || 'TV'
  end

  def thumbnails
    [thumbnail_url]
  end

  def overlay
    overlay_code
  end

  def overlay_link
  end
end
# alias
class Media < Medium; ;end
