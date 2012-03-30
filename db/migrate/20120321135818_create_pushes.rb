class CreatePushes < ActiveRecord::Migration
  def change
    create_table :pushes do |t|
      t.integer :video_id
      t.integer :user_id
      t.string :content

      t.timestamps
    end
  end
end
