class Category < ActiveRecord::Base
  validates :title, presence: true
  has_many :media_categories
  has_many :media, through: :media_categories
end
