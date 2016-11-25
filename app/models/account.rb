class Account < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user, case_sensitive: false }
end
