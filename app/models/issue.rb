class Issue < ApplicationRecord
    belongs_to :user
    belongs_to :assignee, class_name: 'User', foreign_key: :assignee_id
    has_many :comments, dependent: :destroy
    has_many :votes, dependent: :destroy
    has_many :watchers, dependent: :destroy
    validates :Title, :Type, :Priority, :Status, presence: true
    def self.status
        ["New", "Open", "On hold", "Resolved", "Duplicate", "Invalid", "Won't fix", "Closed"]
    end
    def self.type
        ["Bug", "Enhancement", "Proposal", "Task"]
    end
    def self.priority
        ["Trivial", "Minor", "Major", "Critical", "Blocker"]
    end
end
