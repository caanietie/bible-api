class Wordlist < ApplicationRecord
  has_many :wordlistverses, dependent: :destroy

  validates :word, presence: true, uniqueness: true
end
