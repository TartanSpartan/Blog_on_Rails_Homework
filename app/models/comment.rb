class Comment < ApplicationRecord
    belongs_to :post
    validates :body, length: {minimum: 10} # Require at least 10 characters for a comment
end