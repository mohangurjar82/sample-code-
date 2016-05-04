class Category < ActiveRecord::Base
  validates :title, presence: true
  has_many :media_categories
  has_many :media, through: :media_categories

  belongs_to :category
  has_many :categories

  mount_uploader :picture, PictureUploader, mount_on: :image

  # mpx compatibility
  def thumbnail_url
    self_image = picture.present? ? picture_url : image_url
    return self_image if self_image
    medium = media.where('image IS NOT NULL').limit(0).first
    medium.thumbnail_url
  end

  def self.root_categories
    Category.where(category_id: nil).select { |x| !(x.title =~ /books|games/i) }
  end
end
