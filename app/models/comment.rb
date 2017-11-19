class Comment < ApplicationRecord
  belongs_to :issue
  belongs_to :user
  has_attached_file :attachment, styles: { medium: "300x300>", thumb: "100x100>" },
    :storage => :cloudinary,
    :path => ':id/:style/:filename',
    :cloudinary_resource_type => :image

  validates_attachment_content_type :attachment, content_type: /\Aimage\/.*\z/
  
  default_scope { order(created_at: :asc) }
end
