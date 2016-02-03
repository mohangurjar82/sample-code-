class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def avatar
    gravatar_id = Digest::MD5::hexdigest(email).downcase
    "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identicon&s=150"
  end

  def mpx_user
    url = "https://identity.auth.theplatform.com/idm/web/Self/getSelf?schema=1.0&form=json&token=#{mpx_token}"
    OpenStruct.new(JSON.parse(HTTParty.get(url).body)['getSelfResponse'])
  end

end
