class API::ChaptersController < API::ApplicationController
  def show
    hsh = {book: params[:book], chapter: params[:chapter].to_i, verse: 1}
    bible_passage = Berean.from_h hsh
    book = Book.find_by name: bible_passage.book
    chapter = book.chapters.find_by chapter: bible_passage.chapter
    render json: {
      id: chapter.id, book_id: book.id,
      book_name: book.name, chapter: chapter.chapter,
      previous_chapter: {
        book_name: bible_passage.previous_chapter.book,
        chapter: bible_passage.previous_chapter.chapter
      },
      next_chapter: {
        book_name: bible_passage.next_chapter.book,
        chapter: bible_passage.next_chapter.chapter
      },
      # TODO: Add info_text column to the chapters table and uncomment below
      info_html: chapter.info_html #, info_text: chapter.info_text
    }
  end
end
