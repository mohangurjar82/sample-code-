require "administrate/base_dashboard"

class MediumDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    media_categories: Field::HasMany,
    categories: HasManyListField,
    id: Field::Number,
    admin_user_id: Field::Number,
    title: Field::String,
    description: Field::Text,
    number: Field::String,
    image_url: Field::String,
    source_url: Field::String,
    extra_sources: Field::Text,
    language: Field::String,
    rating: Field::Number,
    price: Field::Number,
    order: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :title,
    :description,
    :categories,
    :order,
    :rating,
    :price,
    :created_at,
    :updated_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :title,
    :description,
    :categories,
    :number,
    :image_url,
    :source_url,
    :extra_sources,
    :language,
    :rating,
    :price,
    :order,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :title,
    :description,
    :categories,
    :number,
    :image_url,
    :source_url,
    :extra_sources,
    :language,
    :rating,
    :price,
    :order,
  ].freeze

  # Overwrite this method to customize how media are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(medium)
    medium.title || "Medium ##{medium.id}"
  end
end
