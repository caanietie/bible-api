class API::VersesController < API::ApplicationController
  def index
    render json: versify
  end

  def show
    render json: versify(true)
  end

  private

  def versify from_show_action = false
    hsh = {book: params[:book], chapter: params[:chapter].to_i, verse: 1}
    bible_passage = Berean.from_h hsh
    book = Book.find_by name: bible_passage.book
    chapter = book.chapters.find_by chapter: bible_passage.chapter
    verse = chapter.verses.select(%i[id verse info_html info_text]).distinct
    verse = verse.where(verse: normalize_verse(params[:verse])) if from_show_action
    {
      book_id: book.id, book_name: book.name,
      chapter: chapter.chapter, verses: verse
    }
  end

  # There should be a better way of doing these.
  def normalize_verse verse_str
    illegal_verse_str = /[,\-]{2,}|[^0-9\-,]/
    unless verse_str.match? illegal_verse_str
      verse_str.split(?,).map do |itm|
        if itm.include? ?-
          bg, ed = itm.split(?-).map &:to_i
          bg && ed ? bg .. ed : []
        else
          itm.to_i
        end
      end.flatten
    end
  end
end
