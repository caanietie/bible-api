class API::KJVBibleController < API::ApplicationController
  include berean

  def show
    passages = BiblePassage.multiple_passages params[:id]
    book = Book.find_by name: passages[0].book_name
    psg = hashify_passages(passages).map do |chap, vers|
      book.chapters.find_by(chapter: chap).verses
        .select(%i[id chapter_id verse info_html info_text])
        .where(verse: vers).distinct
    end.flatten
    render json: psg
  end

  private

  def hashify_passages psg_arry
    chap_vers = {}
    psg_arry.each do |psg|
      if chap_vers.has_key? psg.chapter
        chap_vers[psg.chapter].push psg.verse
      else
        chap_vers[psg.chapter] = [psg.verse]
      end
    end
    chap_vers
  end
end
