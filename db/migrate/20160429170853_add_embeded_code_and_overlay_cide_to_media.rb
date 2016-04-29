class AddEmbededCodeAndOverlayCideToMedia < ActiveRecord::Migration
  def change
    add_column :media, :embedded_code, :text
    add_column :media, :overlay_code, :text
  end
end
