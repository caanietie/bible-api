require "test_helper"

class BookTest < ActiveSupport::TestCase
  setup do
    @valid_books = [books(:one), books(:two), books(:three), books(:four)]
    @invalid_books = [books(:five), books(:six), books(:seven)]
  end

  test "should not be nil" do
    [*@valid_books, *@invalid_books].each do |book|
      assert_not_nil book, "book is nil"
    end
  end

  test "should be instance of book" do
    [*@valid_books, *@invalid_books].each do |book|
      assert_instance_of Book, book, "is not an instance of book"
    end
  end

  test "should respond to #id, #name, and #chapters" do
    [*@valid_books, *@invalid_books].each do |book|
      assert_respond_to book, :id, "did not respond to #id"
      assert_respond_to book, :name, "did not respond to #name"
      assert_respond_to book, :chapters, "did not respond to #chapter"
    end
  end

  test "name should satisfy criteria" do
    @valid_books.each do |book|
      assert book.name.length.between? Book::SHORTEST, Book::LONGEST
    end
  end

  test "should save book" do
    @valid_books.each do |book|
      assert book.save, "did not save book"
    end
  end

  test "name should not satisfy criteria" do
    @invalid_books.each do |book|
      assert_not book.name.length.between? Book::SHORTEST, Book::LONGEST
    end
  end

  test "should not save book" do
    @invalid_books.each do |book|
      assert_not book.save, "did save book"
    end
  end

  teardown do
    @valid_books = nil
    @invalid_books = nil
    Rails.cache.clear
  end
end