class LinkIssueWithUser < ActiveRecord::Migration[5.1]
  def change
    rename_column :issues, :Creator, :user_id
  end
end
