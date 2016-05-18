class MechatController < ApplicationController
  <<<<<<< HEAD

  layout "new_layout"
  =======
      before_action :authenticate_user!
  layout 'new_layout'

  >>>>>>> dcff15ce7c75ea9c632208b8c4ffb0404467a2e5
  def index
  end
end
