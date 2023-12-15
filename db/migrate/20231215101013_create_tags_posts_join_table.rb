class CreateTagsPostsJoinTable < ActiveRecord::Migration[7.0]
  def change
      create_join_table :tags, :posts do |t|
      end
  end
end
