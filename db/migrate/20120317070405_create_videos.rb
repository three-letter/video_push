class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :url
      t.string :image
      t.string :plugin
      t.integer :push

      t.timestamps
    end
  end
end
