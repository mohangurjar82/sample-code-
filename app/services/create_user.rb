class CreateUser

  def initialize(create_pluser)
    self.create_pluser = create_pluser
  end

  def self.build
    new CreatePluser.build
  end

  def call(user_params)
    user = User.new user_params
    
    if user.valid?
      result = create_pluser.call(user)

      if result.pluser_created?
        user.save
      else
        user.errors.add :base, result.error_message
      end
    end

    user
  end

  private

  attr_accessor :create_pluser
end