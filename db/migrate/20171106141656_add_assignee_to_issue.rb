class AddAssigneeToIssue < ActiveRecord::Migration[5.1]
  def change
    remove_column :issues, :Assignee
    add_column :issues, :assignee_id, :string
  end
end
