class Book < ApplicationRecord
  SHORTEST = 3 # Job
  LONGEST = 15 # 1 Thessalonians

  has_many :chapters, dependent: :destroy
  has_many :verses, through: :chapters, dependent: :destroy
  has_many :wordlistverses, through: :verses, dependent: :destroy
  has_many :wordlist, through: :wordlistverses, dependent: :destroy

  validates :name, uniqueness: true, length: { in: SHORTEST .. LONGEST }
end
