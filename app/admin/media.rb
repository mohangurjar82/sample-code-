ActiveAdmin.register Media do
  permit_params :admin_user_id, :title, :description, :number, :image_url,
                :source_url, :extra_sources, :language, :rating, :price, :order

  index do
    selectable_column
    id_column
    column :title
    column :description
    column :created_at
    actions
  end

  filter :title
  filter :number
  filter :language
  filter :created_at

  form do |f|
    f.inputs "Media Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
