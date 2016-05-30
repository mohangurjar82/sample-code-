class CategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :picture_url, :number, :parent_category

  has_many :categories

  def parent_category
    if object.category_id.present?
      {
        id: object.category.id,
        title: object.category.title
      }
    end
  end
end