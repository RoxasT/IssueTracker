class ChangePriorityType < ActiveRecord::Migration[5.1]
  def change
    change_column :Issues, :Priority, :string
  end
end
