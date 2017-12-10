class IssueIndexSerializer < ActiveModel::Serializer
    attributes :id, :Title, :Description, :Type, :Priority, :Status, :Votes, :Watchers, :is_voted_by_current_user, :is_watched_by_current_user, :created_at, :updated_at, :_links
    
    def _links
        links = {
            self: { href: "/issues/#{object.id}" },
            creator: { href: "/users/#{object.user_id}" },
            assignee: { href: "/users/#{object.assignee_id}" },
        }
    end
    
    def is_voted_by_current_user
        Vote.exists?(:issue_id => object.id, :user_id => current_user.id)
    end
    
    def is_watched_by_current_user
        Watcher.exists?(:issue_id => object.id, :user_id => current_user.id)
    end
    
end