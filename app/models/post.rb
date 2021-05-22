class Post < ApplicationRecord

    has_many :comments, dependent: :destroy
    belongs_to :user

    before_save :capitalize_title # Include this as a function to be run before saving, and to account for case insensitivity

    # Validations
    validates :title, presence: true, uniqueness: { case_sensitive: false } 
    # The case_sensitive option will make uniqueness validation ignore case.
    # Other than that, we enforce that the title column must be present and unique.

    validates :body, presence: true, length: {minimum: 50}
    # Likewise, the body column must be present and contain a minimum of 50 characters.

    private

    def capitalize_title
        self.title.capitalize!
    end

end