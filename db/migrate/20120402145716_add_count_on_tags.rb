class AddCountOnTags < ActiveRecord::Migration
  def change
    add_column :tags, :count, :integer, :default => 0
  end
end
