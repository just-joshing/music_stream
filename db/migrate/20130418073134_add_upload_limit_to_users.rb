class AddUploadLimitToUsers < ActiveRecord::Migration
  def change
    add_column :users, :upload_limit, :integer, { default: 100, null: false }
  end
end
