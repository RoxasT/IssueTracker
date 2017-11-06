class Issue < ApplicationRecord
    belongs_to :user
    validates :Title, :Type, :Priority, presence: true
end
