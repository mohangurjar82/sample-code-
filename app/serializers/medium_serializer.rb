class MediumSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :number, :image_url, :source_url,
             :extra_sources, :language, :rating, :order, :embedded_code,
             :overlay_code, :created_at, :updated_at, :image, :pricing_plan_id,
             :is_a_game, :medium_id, :picture, :language_list
end