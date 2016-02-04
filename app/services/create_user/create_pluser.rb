class CreateUser
  class CreatePluser
    Result = ImmutableStruct.new(:pluser_created?, :error_message)

    def initialize(tpdata)
      self.tpdata = tpdata
    end

    def self.build
      new ThePlatform::Data
    end

    def call(user)
      #create pluser in tpdata
      #return error if any
      Result.new(pluser_created: true)
    end

    private

    attr_accessor :tpdata
  end
end
