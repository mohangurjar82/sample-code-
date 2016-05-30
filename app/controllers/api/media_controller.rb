class Api::MediaController < Api::BaseController
  def index
    render json: Medium.order('media.order DESC')
  end

  def show
    medium = Medium.where('id = :id OR number = :id', id: params[:id])
    if medium.present?
      render json: medium
    else
      render json: { errors: 'Media not found' }, status: 404
    end
  end
end