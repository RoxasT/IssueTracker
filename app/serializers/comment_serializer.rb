class CommentSerializer < ActiveModel::Serializer
  
      attributes :id, :body, :created_at, :updated_at, :_links
  
      def _links
        if object.attachment.file?
          links = {
              self: { href: "/issues/#{object.issue_id}/comments/#{object.id}"},
              creator: { href: "/users/#{object.user_id}"},
              issue: {href: "/issues/#{object.issue_id}"},
              attachment: {href: "/issues/#{object.issue_id}/comments/#{object.id}/attachment"} 
          }
        else
          links = {
            self: { href: "/issues/#{object.issue_id}/comments/#{object.id}"},
            creator: { href: "/users/#{object.user_id}"},
            issue: {href: "/issues/#{object.issue_id}"},
          }
        end
      end
  
  end