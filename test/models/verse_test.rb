require "test_helper"

class VerseTest < ActiveSupport::TestCase
  setup do
    @valid_verses = [verses(:one), verses(:two), verses(:three), verses(:four)]
    @invalid_verses = [verses(:five), verses(:six), verses(:seven)]
  end

  test "should not be nil" do
    [*@valid_verses, *@invalid_verses].each do |verse|
      assert_not_nil verse, "verse is nil"
    end
  end

  test "should respond to #id, #verse, #info_*, #chapter, #book" do
    [*@valid_verses, *@invalid_verses].each do |verse|
      assert_respond_to verse, :id, "did not respond to #id"
      assert_respond_to verse, :verse, "did not respond to #verse"
      assert_respond_to verse, :info_html, "did not respond to #info_html"
      assert_respond_to verse, :info_text, "did not respond to #info_text"
      assert_respond_to verse, :chapter, "did not respond to #chapter"
      assert_respond_to verse, :book, "did not respond to #book"
    end
  end

  test "should have the right instances" do
    [*@valid_verses, *@invalid_verses].each do |verse|
      assert_instance_of Verse, verse, "not an instance of Verse"
      assert_instance_of Chapter, verse.chapter, "not an instance of Chapter"
      assert_instance_of Book, verse.book, "not an instance of Book"
    end
  end

  test "should pass validation for Verse" do
    @valid_verses.each do |verse|
      assert verse.verse.between? 1, Verse::LONGEST
      assert verse.info_html.length >= Verse::SHORTEST, "info_html not passed"
      assert verse.info_text.length >= Verse::SHORTEST, "info_text not passed"
    end
  end

  test "should pass validation for Chapter" do
    @valid_verses.each do |verse|
      chapter = verse.chapter
      assert chapter.chapter.between? 1, Chapter::LONGEST
      assert chapter.info_html.present?, "info_html not passed"
    end
  end

  test "should pass validation for Book" do
    @valid_verses.each do |verse|
      book = verse.book
      assert book.name.length.between? Book::SHORTEST, Book::LONGEST
    end
  end

  test "should save verse" do
    @valid_verses.each do |verse|
      assert verse.save, "verse did not save"
    end
  end

  test "should not pass validation for Verse" do
    @invalid_verses.each do |verse|
      assert_not verse.verse.between?(1, Verse::LONGEST) && 
        verse.info_html.length >= Verse::SHORTEST && 
        verse.info_text.length >= Verse::SHORTEST, "verse passed"
    end
  end

  test "should not pass validation for Chapter" do
    @invalid_verses.each do |verse|
      chapter = verse.chapter
      assert_not chapter.info_html.present? &&
        chapter.chapter.between?(1, Chapter::LONGEST)
    end
  end

  test "should not pass validation for Book" do
    @invalid_verses.each do |verse|
      book = verse.book
      assert_not book.name.length.between? Book::SHORTEST, Book::LONGEST
    end
  end

  test "should not save verse"do
    @invalid_verses.each do |verse|
      assert_not verse.save
    end
  end

  teardown do
    @valid_verses = nil
    @invalid_verses = nil
    Rails.cache.clear
  end
end