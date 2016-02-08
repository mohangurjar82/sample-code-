class CreateUser

  def initialize(create_pluser, signin_pluser)
    self.create_pluser = create_pluser
    self.signin_pluser = signin_pluser
  end

  def self.build
    new CreatePluser.build, ::SigninPluser.build
  end

  def call(user_params)
    user = User.new user_params
    
    if user.valid?
      result = create_pluser.call(user)

      if result.pluser_created?
        user.mpx_user_id = result.id
        
        signin_result = signin_pluser.call(user_params.slice(:email, :password))

        if signin_result.pluser_signedin?
          user.mpx_token = signin_result.token
          user.save
        else
          user.errors.add :base, signin_result.error_message
        end
      else
        user.errors.add :base, result.error_message
      end
    end

    user
  end

  private

  attr_accessor :create_pluser, :signin_pluser
end
