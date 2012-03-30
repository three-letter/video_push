class AddTagsToPushes < ActiveRecord::Migration
  def change
    add_column :pushes, :tags, :string
  end
end
