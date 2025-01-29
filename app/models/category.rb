class Category < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
end
