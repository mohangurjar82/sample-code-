class CreateMediaCategories < ActiveRecord::Migration
  def change
    create_table :media_categories do |t|
      t.integer :media_id, index: true
      t.integer :category_id, index: true

      t.timestamps null: false
    end
  end
end
