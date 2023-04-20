module API
  class SearchController < ApplicationController
    def show
      render json: {
        search: {
          value: params[:id],
          data: search_word(params[:id].split.join(' ').downcase)
        }
      }
    end

    private

    def search_word params_id
      if params_id.split.length.eql? 1
        Wordlist.find_by(word: params_id)&.wordlistverses
            &.map(&:verse)&.each_with_object([]) do |verse, obj|
          obj.push result_hash(params_id, verse)
        end || []
      else
        search_phrase params_id
      end
    end

    def search_phrase params_id
      Verse.all.filter{|v| v.info_text.downcase.include?(params_id)}
          .each_with_object([]) do |verse, obj|
        obj.push result_hash(params_id, verse)
      end
    end

    def result_hash params_id, verse
      chapter = verse.chapter
      book = verse.book
      {
        book_id: book.id, book_name: book.name,
        chapter_id: chapter.id, chapter: chapter.chapter,
        verse_id: verse.id, verse: verse.verse,
        info_text: verse_info(params_id, verse.info_text)
      }
    end

    def verse_info params_id, info_text
      arry = info_text.split
      return info_text if arry.length <= 10
      frst = arry[...arry.length / 2].join ' '
      scnd = arry[arry.length / 2 ..].join ' '
      frst.match?(/#{params_id}/i) ? "#{frst} ..." : "... #{scnd}"
    end
  end
end
