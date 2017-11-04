class AddVotesToIssues < ActiveRecord::Migration[5.1]
  def change
    add_column :Issues, :Votes, :integer, {default:0}
  end
end
