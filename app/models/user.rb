class User < ApplicationRecord

    has_many :posts, dependent: :nullify
    has_many :comments, dependent: :nullify

    # Validations: check for a unique, present email using regex (expression taken from Amazing Amazon project)
    validates :first_name, :last_name, presence: true
    validates :email, presence: true, uniqueness: true,
    format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :password, presence: true, length: {minimum: 8}

    has_secure_password

    def full_name
        "#{first_name} #{last_name}".strip.capitalize!
    end
end