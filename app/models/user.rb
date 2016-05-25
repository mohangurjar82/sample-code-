class User < ActiveRecord::Base
  PROMO_CODE_REGEXP = /\ASCI([0-2]\d\d|300)$/i

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  acts_as_token_authenticatable

  has_many :subscriptions

  validates :name, :email, presence: true
  validates_uniqueness_of :email
  validate :confirmation_matches_password
  
  AVATAR = { :default => 0, :gravatar => 1, :uploaded => 2 }

  mount_uploader :avatar, AvatarUploader

  attr_accessor :promo_code

  def gravatar
    gravatar_id = Digest::MD5::hexdigest(email).downcase
    "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identicon&s=150"
  end

  def avatar_url
    if self.avatar_option == AVATAR[:default]
      '/img/avatars/user.png'
    elsif self.avatar_option == AVATAR[:gravatar]
      gravatar
    else
      self.avatar.thumb.url
    end
  end

  def display_name
    name.present? ? name : email
  end

  def push_media_to_history(media_id)
    recently_viewed_media_ids.unshift(media_id)
    self.recently_viewed_media_ids = self.recently_viewed_media_ids.uniq[0..15]
    update_attributes(recently_viewed_media_ids: self.recently_viewed_media_ids)
  end

  def recently_viewed_media
    recently_viewed_media_ids.map do |number|
      MPX::Media.find_by_number(number)
    end
  end

  def favorite_media
    FavoriteMedium.where(user_id: id).map do |fm|
      MPX::Media.find_by_number(fm.media_number)
    end
  end

  class Promo
    def self.find_or_create_by_code(code)
      return false unless code.match(User::PROMO_CODE_REGEXP)
      user = User.find_or_create_by(email: "#{code}@n2me.tv".downcase)
      user.password = code * 2
      user.save(validate: false) && user
    end
  end

  private

  def confirmation_matches_password
    unless self.password == password_confirmation
      errors.add(:base, "Password confirmation doesn't match password")
    end
  end
end
