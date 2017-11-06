class Issue < ApplicationRecord
    belongs_to :user
    belongs_to :assignee, class_name: 'User', foreign_key: :assignee_id
    validates :Title, :Type, :Priority, presence: true
end
