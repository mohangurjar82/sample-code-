class Category < ActiveRecord::Base
  validates :title, presence: true
  has_many :media_categories
  has_many :media, through: :media_categories

  belongs_to :category
  has_many :categories

  mount_uploader :picture, PictureUploader, mount_on: :image
end
