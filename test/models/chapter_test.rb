require "test_helper"

class ChapterTest < ActiveSupport::TestCase
  setup do
    @valid_chapters = [chapters(:one), chapters(:two), chapters(:three), chapters(:four)]
    @invalid_chapters = [chapters(:five), chapters(:six), chapters(:seven)]
  end

  test "should not be nil" do
    [*@valid_chapters, *@invalid_chapters].each do |chapter|
      assert_not_nil chapter, "is nil"
    end
  end

  test "should respond to #book, #chapter, #verses, and #info_html" do
    [*@valid_chapters, *@invalid_chapters].each do |chapter|
      assert_respond_to chapter, :book, "did not respond to #book"
      assert_respond_to chapter, :verses, "did not respond to #verses"
      assert_respond_to chapter, :chapter, "did not respond to #chapter"
      assert_respond_to chapter, :info_html, "did not respond to #info_html"
    end
  end

  test "should have the correct instances" do
    [*@valid_chapters, *@invalid_chapters].each do |chapter|
      assert_instance_of Chapter, chapter, "not an instance of chapter"
      assert_instance_of Book, chapter.book, "not an instance of book"
    end
  end

  test "should pass validations for Chapter" do
    @valid_chapters.each do |chapter|
      assert chapter.info_html.present?
      assert chapter.chapter.between? 1, Chapter::LONGEST
    end
  end
  
  test "shpuld pass validatioin for Book" do
    @valid_chapters.each do |chapter|
      book = chapter.book
      assert book.name.length.between? Book::SHORTEST, Book::LONGEST
    end  
  end

  test "should save chapter" do
    @valid_chapters.each do |chapter|
      assert chapter.save, "chapter was not saved"
    end
  end

  test "should not pass validations for Chapter" do
    @invalid_chapters.each do |chapter|
      assert_not chapter.info_html.present? &&
      chapter.chapter.between?(1, Chapter::LONGEST)
    end
  end
  
  test "should not pass validation for Book" do
    @invalid_chapters.each do |chapter|
      book = chapter.book
      assert_not book.name.length.between? Book::SHORTEST, Book::LONGEST
    end
  end

  test "should not save chapter" do
    @invalid_chapters.each do |chapter|
      assert_not chapter.save, "chapter was saved"
    end
  end

  teardown do
    @valid_chapters = nil
    @invalid_chapters = nil
    Rails.cache.clear
  end
end