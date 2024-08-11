# frozen_string_literal: true

require_relative "berean/util"
require_relative "berean/passage"
require_relative "berean/version"

class Berean
  # @return [String] the book name
  attr_reader :book

  # @return [Integer] the chapter in the book
  attr_reader :chapter

  # @return [Integer] the verse in the chapter
  attr_reader :verse

  class << self
    # Bible passage of chapter 1 verse 1 of a given book
    # @param book (see #initialize)
    # @return [Berean] the bible passage
    # @!visibility private
    private def chapter_one_verse_one book
      new book, 1, 1
    end

    # The first passage in the bible
    # @return (see #chapter_one_verse_one)
    def first_passage
      chapter_one_verse_one "Genesis"
    end
    alias first first_passage

    # The last passage in the bible
    # @return (see #chapter_one_verse_one)
    def last_passage
      new "Revelation", 22, 21
    end
    alias last last_passage

    # Bible passage from a given string
    # @param psg [String] the bible passage string
    # @return (see #chapter_one_verse_one) or
    #   raise Berean::Error if psg is not recognized
    # @note Format of the String is `book chapter:verse`
    def from_s psg
      rx = /\A(?<book>(?:[1-3]{,1}\s*)?(?:[a-z]+\s*){1,3})
        (?<chapter>[1-9]\d{0,2})\s*:\s*(?<verse>[1-9]\d{0,2})\z/ix
      unless psg.strip.match? rx
        err_msg = sprintf("Bible passage error: %s", psg)
        raise Berean::Error, err_msg
      end
      hsh = psg.strip.match(rx).named_capture
      # hsh[:book] = hsh[:book].strip if hsh[:book]
      hsh[:chapter] = hsh[:chapter].strip.to_i if hsh[:chapter]
      hsh[:verse] = hsh[:verse].strip.to_i if hsh[:verse]
      from_h hsh
    end

    # Bible passage from a given hash
    # @param hsh [Hash] the bible passage hash
    # @return (see #chapter_one_verse_one) or
    #   raise Berean::Error if hsh is not recognized
    # @note hsh must contain keys `book`, `chapter`, `verse`
    def from_h hsh
      hsh.transform_keys! &:to_sym
      unless hsh[:book] && hsh[:chapter] && hsh[:verse]
        err_msg = "missing keys book, chapter, or verse"
        raise Berean::Error, err_msg
      end
      new hsh[:book], hsh[:chapter], hsh[:verse]
    end

    # Random bible passage
    # @param book [String, nil] the book name or nil
    # @param chapter [Integer, nil] the chapter of the
    #   book or nil
    # @return (see #chapter_one_verse_one) or raises an
    #   error if `book` or `chapter` is not recognized
    # @note if `book` or/and `chapter` is given, a random
    #   verse is selected from the book and chapter
    def random_passage book = nil, chapter = nil
      if book && !passage_exist?(book, chapter || 1, 1)
        err_msg = "Bible passage error: book: %s chapter: %d"
        raise Berean::Error, sprintf(err_msg, book, chapter)
      end
      new(*random_verse(book, chapter))
    end
    alias random random_passage

    # Multiple bible passages from a given book
    # @param mult_psg [String] the passages string
    # @return [Array] of (see #chapter_one_verse_one) or
    #   raise an error if `mult_psg` is not recognized
    # @note Each chapter with verses are seperated by `;`,
    #   verses are seperated by `,`, while verse
    #   range are seperated by `-`
    def passages mult_psg
      many_passages(mult_psg).each_with_object([]) do |psg, obj|
        book, chap_vers = psg
        chap_vers.each_pair do |chap, vers|
          obj.push(*vers.map{ |vrs| new(book, chap, vrs) })
        end
      end
    end
  end

  # Creates a new bible passage
  # @param book [String] the book name
  # @param chapter [Integer] the chapter in the book
  # @param verse [Integer] the verse in the chapter
  # @note raise an error if `book`, `chapter`, or
  #   `verse` is not recognized
  def initialize book, chapter, verse
    unless Berean.exist? book, chapter, verse
      err_msg = "Bible passage error: book: %s chapter: %d verse: %d"
      raise Berean::Error, format(err_msg, book, chapter, verse)
    end
    @book = Berean.norm_book book
    @chapter = chapter
    @verse = verse
  end

  # String representation  of bible passage
  # @return [String] the string representation
  def to_s
    sprintf "%s %d:%d", @book, @chapter, @verse
  end

  # Hash representation of bible passage
  # @return [Hash] the hash representation
  def to_h
    { book: @book, chapter: @chapter, verse: @verse }
  end

  # Compare two bible passages
  # @param other [Berean] the other passage
  # @return [Boolean]
  def eql? other
    @book.eql?(other.book) &&
      @chapter.eql?(other.chapter) &&
      @verse.eql?(other.verse)
  end

  # The next bible passage verse relative to self
  # @param wrap [Boolean]
  # @return [Berean] the next bible passage verse
  # @note when `wrap` is true, next verse after Revelation
  #   chapter 22 verse 21 will be Genesis chapter 1 verse 1
  #   otherwise it stays at Revelation chapter 22 verse 21
  def next_verse wrap = false
    if Berean.exist? @book, @chapter, @verse + 1
      Berean.new @book, @chapter, @verse + 1
    elsif Berean.exist? @book, @chapter + 1, 1
      Berean.new @book, @chapter + 1, 1
    elsif bk = Berean.next_book(@book)
      Berean.chapter_one_verse_one bk
    else
      wrap ? Berean.first_passage : Berean.last_passage
    end
  end
  alias succ next_verse

  # The next bible passage chapter relative to self
  # @param wrap [Boolean]
  # @return [Berean] the next bible passage chapter
  # @note (see #next_verse)
  def next_chapter wrap = false
    verse = Berean.num_verses @book, @chapter
    Berean.new(@book, @chapter, verse).next_verse wrap
  end

  # The previous bible passage verse relative to self
  # @param wrap [Boolean]
  # @return [Berean] the previous bible passage verse
  # @note when `wrap` is true, previous verse after Genesis
  #   chapter 2 verse 1 will be Revelation chapter 22 verse
  #   verse 21 otherwise it stays at Genesis chapter 1 verse 1
  def previous_verse wrap = false
    if Berean.exist? @book, @chapter, @verse - 1
      Berean.new @book, @chapter, @verse - 1
    elsif Berean.exist? @book, @chapter - 1, 1
      verse = Berean.num_verses @book, @chapter - 1
      Berean.new @book, @chapter - 1, verse
    elsif bk = Berean.previous_book(@book)
      chapter = Berean.num_chapters bk
      verse = Berean.num_verses bk, chapter
      Berean.new bk, chapter, verse
    else
      wrap ? Berean.last_passage : Berean.first_passage
    end
  end
  alias pred previous_verse

  # The previous bible passage chapter relative to self
  # @param wrap [Boolean]
  # @return [Berean] the previous bible passage chapter
  # @note (see #previous_verse)
  def previous_chapter wrap = false
    if Berean.exist? @book, @chapter - 1, 1
      Berean.new @book, @chapter - 1, 1
    elsif bk = Berean.previous_book(@book)
      chapter = Berean.num_chapters bk
      Berean.new bk, chapter, 1
    else
      wrap ? Berean.last_passage : Berean.first_passage
    end
  end
end