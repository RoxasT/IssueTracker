json.extract! issue, :id, :Title, :Description, :Type, :Priority, :Status, :Assignee, :Creator, :Created, :Updated, :created_at, :updated_at
json.url issue_url(issue, format: :json)
