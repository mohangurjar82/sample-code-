class MediaCategory < ActiveRecord::Base
  belongs_to :media
  belongs_to :category
  
  validates :media_id, :category_id, presence: true
  validates_uniqueness_of :media_id, scope: :category_id
end
