class AttachmentSerializer < ActiveModel::Serializer
  attributes :attachment_file_name, :attachment_content_type, :attachment_file_size, :attachment_updated_at, :url, :_links

  def url
    url = object.attachment.url
  end

  def _links
    links = {
        comment: { href: "/issues/#{object.issue_id}/comments/#{object.id}"},
        creator: { href: "/users/#{object.user_id}"},
        self: {href: "/issues/#{object.issue_id}/comments/#{object.id}/attachment"} 
    }
  end
end
