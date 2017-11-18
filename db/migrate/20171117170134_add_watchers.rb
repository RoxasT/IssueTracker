class AddWatchers < ActiveRecord::Migration[5.1]
  def change
    add_column :issues, :Watchers, :integer, {default:0}
  end
end
