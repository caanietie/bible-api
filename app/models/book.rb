class Book < ApplicationRecord
  SHORTEST = 3 # Job
  LONGEST = 15 # 1 Thessalonians
  has_many :chapters, dependent: :destroy
  validates :name, uniqueness: true, length: { in: SHORTEST .. LONGEST }
end