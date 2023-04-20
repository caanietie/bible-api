class Chapter < ApplicationRecord
  LONGEST = 150 # Psalms

  belongs_to :book

  has_many :verses, dependent: :destroy
  has_many :wordlistverses, through: :verses, dependent: :destroy
  has_many :wordlists, through: :wordlistverses, dependent: :destroy

  validates :chapter,
    numericality: { only_integer: true, in: 1 .. LONGEST }
  validates :info_html, presence: true, uniqueness: true
end