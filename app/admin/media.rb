ActiveAdmin.register Media do
  permit_params :admin_user_id, :title, :description, :number, :image_url,
                :source_url, :extra_sources, :language, :rating, :price, :order,
                :embedded_code, :overlay_code

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
    f.inputs "Media Details <i class='fa fa-exchange fa-rotate-90 toogle'></i>" do
      f.input :title
      f.input :description, input_html: { rows: 3 }
      if f.object.persisted?
        f.input :number, input_html: { disabled: true }, hint: 'Media number from MPX admin inteface'
      else
        f.input :number, hint: 'Media number from MPX admin inteface (not required for new media)'
      end
      f.input :image_url, hint: 'Media thubmbail'
      f.input :overlay_code, hint: 'HTML code to display on top of media player'
      f.input :source_url, hint: 'Path to m3u8 file'
      f.input :extra_sources, input_html: { rows: 2 }, hint: 'You can use multiple m3u8 file, please put one per line if you need that.'
      columns do
        column do
          f.input :language, as: :select, collection: Languages.list
          f.input :price, hint: 'In cents $0.99 = 99'
        end
        column do
          f.input :rating
          f.input :order
          f.input :admin_user_id, input_html: { type: 'hidden', value: current_admin_user.id }, label: false
        end
     end
    end
    f.actions
  end

end
