class Comment < ApplicationRecord
    belongs_to :post
    belongs_to :user, optional: true
    validates :body, length: {minimum: 2} # Require at least 2 characters for a comment
end