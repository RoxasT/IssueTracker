class IssueSerializer < ActiveModel::Serializer
    attributes :id, :Title, :Description, :Type, :Priority, :Status, :assignee_id, :Votes, :Watchers, :created_at, :updated_at, :_links
    
    def _links
        links = {
            self: { href: "/issues/#{object.id}" },
            creator: object.user_id.as_json_summary,
        }
    end
    
end