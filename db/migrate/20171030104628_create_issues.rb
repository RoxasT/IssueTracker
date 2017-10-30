class CreateIssues < ActiveRecord::Migration[5.1]
  def change
    create_table :issues do |t|
      t.string :Title
      t.string :Description
      t.string :Type
      t.integer :Priority
      t.string :Status
      t.string :Assignee
      t.string :Creator
      t.date :Created
      t.date :Updated

      t.timestamps
    end
  end
end
