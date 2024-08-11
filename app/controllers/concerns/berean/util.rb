# frozen_string_literal: true

require_relative "constant"

class Berean
  class << self
    # The number of books in the bible
    # @return [Integer] the number of books
    def num_books
      CONSTANTS.length
    end

    # The number of chapters in a given book
    # @param bk [String] the book name
    # @return [Integer] the number of chapters
    # @note the book name must be normalized
    def num_chapters bk
      CONSTANTS[bk][0].length
    end

    # The number of verses in chapter of a given book
    # @param (see #num_chapters)
    # @param chp [Integer] the chapter of the book
    # @return [Integer] the number of verses
    # @note (see #num_chapters)
    def num_verses bk, chp
      CONSTANTS[bk][0][chp - 1]
    end

    # The next book in the bible
    # @param curr_bk [String] the current book
    # @return [String] the next book name
    # @note (see #num_chapters)
    def next_book curr_bk
      bks = CONSTANTS.keys
      bks[bks.index(curr_bk) + 1]
    end

    # The previous book in the bible
    # @param (see #next_book)
    # @return [String] the previous book name
    # @note (see #num_chapters)
    def previous_book curr_bk
      bks = CONSTANTS.keys
      ind = bks.index curr_bk
      ind.zero? ? nil : bks[ind - 1]
    end

    # Normalizes the given short book name
    # @param bk [String] the short book name
    # @return [String, nil] the normalized book name
    #   or nil if not `bk` is not recognized
    def norm_book bk
      tmp = bk.strip.downcase
      CONSTANTS.each_pair do |key, value|
        return key if tmp.casecmp?(key) ||
          value[1].any?{ |v| tmp.start_with?(v) || tmp.eql?(v) }
      end
      nil
    end

    # Check that the given book, chapter, and verse exist
    # @param bk [String] the book name
    # @param chp [Integer] the chapter in the book
    # @param vrs [Integer] the verse in the chapter
    # @return [Boolean]
    def passage_exist? bk, chp, vrs
      _bk = norm_book bk
      return false if _bk.nil?
      chp.between?(1, num_chapters(_bk)) && 
        vrs.between?(1, num_verses(_bk, chp))
    end
    alias exist? passage_exist?

    # Random verse of the bible
    # @param bk [String] the book name
    # @param chp [Integer] the chapter in the book
    # @return [Array] Array contains a random book
    #   name, chapter, and verse
    def random_verse bk, chp
      _bk = bk ? norm_book(bk) : CONSTANTS.keys.sample
      _chp = chp || rand(1..num_chapters(_bk))
      _vrs = rand(1..num_verses(_bk, _chp))
      [_bk, _chp, _vrs]
    end
  end
end