class Api::CategoriesController < Api::BaseController

  def index
    render json: Category.order('categories.order DESC')
  end

  def show
    category = Category.where('id = :id OR number = :id', id: params[:id])
    if category.present?
      render json: category
    else
      render json: { errors: 'Category not found' }, status: 404
    end
  end

end