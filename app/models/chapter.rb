class Chapter < ApplicationRecord
  LONGEST = 150 # Psalms
  belongs_to :book
  has_many :verses, dependent: :destroy
  validates :chapter,
    numericality: { only_integer: true, in: 1 .. LONGEST }
  validates :info_html, presence: true, uniqueness: true
end