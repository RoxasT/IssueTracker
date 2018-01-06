class IssueIndexSerializer < ActiveModel::Serializer
    attributes :id, :Title, :Description, :Type, :Priority, :Status, :Votes, :Watchers, :is_voted_by_current_user, :is_watched_by_current_user, :created_at, :updated_at, :_links
    
    def _links
        if object.assignee_id != nil
            links = {
                self: { href: "/issues/#{object.id}" },
                creator: { href: "/users/#{object.user_id}", id: object.user_id, name: User.find(object.user_id).name },
                assignee: { href: "/users/#{object.assignee_id}", id: object.assignee_id, name: User.find(object.assignee_id).name },
            }
        else
            links = {
                self: { href: "/issues/#{object.id}" },
                creator: { href: "/users/#{object.user_id}", id: object.user_id, name: User.find(object.user_id).name },
                assignee: { href: null, id: null, name: null },
            }
        end
    end
    
    def is_voted_by_current_user
        Vote.exists?(:issue_id => object.id, :user_id => current_user.id)
    end
    
    def is_watched_by_current_user
        Watcher.exists?(:issue_id => object.id, :user_id => current_user.id)
    end
    
end