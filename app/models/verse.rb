class Verse < ApplicationRecord
  LONGEST = 176 # Psalms 119
  SHORTEST = 10 # Jesus wept
  belongs_to :book
  belongs_to :chapter
  validates :verse, 
    numericality: { only_integer: true, in: 1 .. LONGEST }
  validates :info_html, uniqueness: true, length: { minimum: SHORTEST }
  validates :info_text, length: { minimum: SHORTEST }
end