class AddtagToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :tags, :string, array: true, default: []
  end
end
