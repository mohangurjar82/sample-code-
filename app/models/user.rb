class User < ActiveRecord::Base
  PROMO_CODE_REGEXP = /\ASCI([0-2]\d\d|300)$/i

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable
  acts_as_token_authenticatable

  has_many :authentications
  has_many :subscriptions
  has_and_belongs_to_many :stations, :join_table => "users_stations"
  has_one :preference

  validates :name, :email, presence: true
  validates_uniqueness_of :email
  validate :confirmation_matches_password
  
  AVATAR = { :default => 0, :gravatar => 1, :uploaded => 2 }

  mount_uploader :avatar, AvatarUploader

  Roles = {
    "ADMIN" => :admin,
    "USER" => :user
  }
  
  # Dynamically generate methods for each role e.g is_admin?
  # as there can be more roles in future
  Roles.each do |constant, name|
    define_method("is_#{name}?"){ self.role == constant.downcase }
  end

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

  def short_name
    name.present? ? name.split(' ')[0] : email.split('@')[0]
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

  def generate_api_authentication_token
    token = Devise.friendly_token
    while User.find_by(authentication_token: token)
      token = Devise.friendly_token
    end
    update_columns(authentication_token: token)
  end

  def subscribed_media
    media = []
    self.subscriptions.each do |sub|
      obj = sub.product.present? ? sub.product : sub
      media = media.concat(plan_media(obj))
    end
    return media.uniq
  end

  def subscribe_to_products
    subscribed_product_ids = self.subscriptions.where.not(:product_id => nil)
    Product.where.not(:id => subscribed_product_ids)
  end

  def subscribe_to_channels
    subscribed_media_ids = []
    self.subscriptions.map{|x| subscribed_media_ids = subscribed_media_ids.concat(x.media.map{|x| x.id})}
    @additional_products = Medium.where.not(pricing_plan: nil, :id => subscribed_media_ids)
  end

  def self.from_omniauth(auth)
    user_email = User.find_by_email auth.info.email
    user_email = "#{auth.uid}@#{auth.provider}.com" if user_email.to_s.blank?

    user_name = auth.info.try("name").to_s.blank? ? '--' : auth.info.try("name").to_s

    @usr = User.find_by_email user_email

    unless @usr
      password = SecureRandom.hex
      @usr = User.create!(
        email: user_email,
        password: password,
        password_confirmation: password,
        name: user_name
      )
      
      @usr.remote_avatar_url = process_uri(auth.info.image)
      @usr.avatar_option = 2
      @usr.save!
      
    end
    authentication = @usr.authentications.where(provider: auth.provider).first

    unless authentication
      authentication = Authentication.create!(
        user_id: @usr.id,
        provider: auth.provider,
        uid: auth.uid,
        oauth_token: auth.credentials.token,
        oauth_expires_at: Time.at(auth.credentials.expires_at)
      )
    end
    return @usr
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

  def plan_media(obj)
    media = []
    media = media.concat(obj.media) if obj.media.present?
    if obj.categories.present?
      category_ids = obj.categories.map{|x| x.id}
      if categories.present?
        media = media.concat(Medium.includes(:media_categories).where("media_categories.category_id" => category_ids))
      end
    end
    return media.uniq
  end

  def confirmation_matches_password
    unless self.password == password_confirmation
      errors.add(:base, "Password confirmation doesn't match password")
    end
  end
  def self.process_uri(uri)
      require 'open-uri'
      require 'open_uri_redirections'
      open(uri, :allow_redirections => :safe) do |r|
          r.base_uri.to_s
      end
  end
end
