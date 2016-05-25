class Api::CategoryMediaController < Api::BaseController

  def index
    category = Category.where('id = :id OR number = :id', id: params[:id]).first
    if category.present?
      render json: category.media.order('media.order DESC')
    else
      render json: { errors: 'Category not found' }, status: 404
    end
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