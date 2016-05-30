class Api::BaseController < ApplicationController
  acts_as_token_authentication_handler_for User, fallback: :none
  skip_before_filter :verify_authenticity_token
end