class Genre < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :user }
end
