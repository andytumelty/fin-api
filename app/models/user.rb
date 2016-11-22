class User < ApplicationRecord

    has_secure_password

    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, on: :create
    validates :password_confirmation, presence: true, on: :create

end
