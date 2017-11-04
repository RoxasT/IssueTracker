json.extract! issue, :id, :Title, :Description, :Type, :Priority, :Status, :Votes, :Assignee, :user_id, :created_at, :updated_at
json.url issue_url(issue, format: :json)
