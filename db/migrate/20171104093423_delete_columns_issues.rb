class DeleteColumnsIssues < ActiveRecord::Migration[5.1]
  def change
    remove_columns :issues, :Created, :Updated
  end
end
