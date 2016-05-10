class Medium < ActiveRecord::Base
  validates :title, presence: true

  has_many :media_categories, dependent: :destroy
  has_many :categories, through: :media_categories

  belongs_to :pricing_plan
  belongs_to :medium
  has_many :media

  mount_uploader :picture, PictureUploader, mount_on: :image

  default_scope -> { where(is_a_game: false) }

  def languages
    @_languages ||= if medium_id.present?
                      Media.where('medium_id = :id OR id = :id', id: medium_id)
                    else
                      [self].concat media
                    end
  end
  
  def language_list
    return medium.language_list if medium_id.present?
    list = [language] + media.pluck(:language)
    list.join.blank? ? ['English'] : list.join(' | ')
  end

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
