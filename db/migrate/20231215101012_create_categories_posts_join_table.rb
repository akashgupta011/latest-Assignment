class CreateCategoriesPostsJoinTable < ActiveRecord::Migration[7.0]
  def change
     create_join_table :categories, :posts do |t|
     end
  end
end
