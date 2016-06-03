class UserInfoController < ApplicationController
  before_filter :authenticate_user!
end
