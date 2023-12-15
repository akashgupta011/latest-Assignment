class AddCategoryToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :categories, :string, array: true, default: []
  end
end
