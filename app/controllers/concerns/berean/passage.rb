# frozen_string_literal: true

require_relative "error"

class Berean
  class << self
    def many_passages mult_psg
      unless mult_psg.match?(/[^a-z\d:,\-;]|[:,\-;]{2,}/i)
        err_msg = "Only characters in [A-za-z0-9:,-;] are allowed"
        raise Berean::Error, err_msg
      end
      book = get_book mult_psg
      ch_vr = get_chapter_verse mult_psg
      psg = ch_vr.split(?;).each_with_object({}) do |chap_vers, obj|
        chapter, chp_vrs = get_chapter(chap_vers)
        obj[chapter] = get_verse(chp_vrs)
      end
      {book => psg}
    end

    private

    def get_book mult_psg
      book = mult_psg[..mult_psg.rindex(/[a-z]/i)].strip
      unless book.match?(/[1-3a-z\s]/i) &&
          book.match?(/\A(?:(?:[1-3]{,1}\s*)?(?:[a-z]+\s*){1,3})\z/i)
        err_msg = "Only characters in [1-3A-Za-z] are allowed: %s"
        raise Berean::BookError, format(err_msg, book)
      end
      book
    end

    def get_chapter_verse mult_psg
      chap_vers = mult_psg[mult_psg.rindex(/[a-z]/i)+1..].strip
      unless chap_vers.match?(/[\d:,\-;]/)
        err_msg = "Only characters in [0-9:,-;] are allowed: %s"
        raise Berean::BookError, format(err_msg, chap_vers)
      end
      chap_vers
    end

    def get_chapter chap_vers
      unless chap_vers.strip.match?(/[\d:,\-]/)
        err_msg = "Only characters in [0-9:,-] are allowed: %s"
        raise Berean::Error, format(err_msg, chap_vers)
      end
      chp_vrs = chap_vers.split(?:).map(&:strip)
      unless chp_vrs.length.eql?(2) &&
          chp_vrs[0].match?(/\A[1-9]\d{,2}\z/)
        err_msg = "Only characters in [0-9] are allowed: %s"
        raise Berean::ChapterError, err_msg % chp_vrs[0]
      end
      [chp_vrs[0].to_i, chp_vrs[1]]
    end

    def get_verse chp_vrs
      unless chp_vrs.match?(/[\d,\-]/)
        err_msg = "Only characters in [0-9,-] are allowed: %s"
        raise Berean::VerseError, format(err_msg, chp_vrs)
      end
      chp_vrs.split(?,).each_with_object([]) do |vrs, obj|
        if vrs.include?(?-) &&
            (vr = vrs.split(?-)).length.eql?(2) &&
            vr.all?{ |v| v.strip.match?(/\A[1-9]\d{,2}\z/) }
          obj.push(*Range.new(*vr.map(&:strip).map(&:to_i)))
        elsif vrs.strip.match?(/\A[1-9]\d{,2}\z/)
          obj.push vrs.strip.to_i
        else
          err_msg = "Verse is not recognized: #{chp_vrs}"
          raise Berean::VerseError, err_msg
        end
      end
    end
  end
end