class User < ActiveRecord::Base
  PROMO_CODE_REGEXP = /\ASCI([0-2]\d\d|300)$/i

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :orders
  
  attr_accessor :promo_code

  def avatar
    gravatar_id = Digest::MD5::hexdigest(email).downcase
    "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identicon&s=150"
  end

  def display_name
    name.present? ? name : email
  end

  class Promo
    def self.find_or_create_by_code(code)
      return false unless code.match(User::PROMO_CODE_REGEXP)
      user = User.find_or_create_by(email: "#{code}@n2me.tv".downcase)
      user.password = code * 2
      user.save && user
    end
  end
end
