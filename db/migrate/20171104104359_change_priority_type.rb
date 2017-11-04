class ChangePriorityType < ActiveRecord::Migration[5.1]
  def change
    change_column :issues, :Priority, :string
  end
end
