class AddVotesToIssues < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :Votes, :integer, {default:0}
  end
end
