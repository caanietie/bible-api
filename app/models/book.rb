class Book < ApplicationRecord
  SHORTEST = 3 # Job
  LONGEST = 15 # 1 Thessalonians
  validates :name, uniqueness: true, length: { within: 3 .. 15 }
end