class AddAttachmentAttachmentToComments < ActiveRecord::Migration[4.2]
  def self.up
    change_table :comments do |t|
      t.attachment :attachment
    end
  end

  def self.down
    remove_attachment :comments, :attachment
  end
end
