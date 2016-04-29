class Medium < ActiveRecord::Base
  validates :title, :source_url, presence: true

  has_many :media_categories
  has_many :categories, through: :media_categories

end
# alias
class Media < Medium; ;end
