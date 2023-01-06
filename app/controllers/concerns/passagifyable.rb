# frozen_string_literal = true

module Passagifyable
  
  private
  
  MIN_BOOK_LENGTH = 2
  MAX_BOOK_LENGTH = 19
  BOOK_NAMES = {
    "Genesis" => ["ge", "gen", "gene"],
    "Exodus" => ["ex", "exo", "exod"],
    "Leviticus" => ["le", "lev", "levi"],
    "Numbers" => ["nu", "num", "numb"],
    "Deuteronomy" => ["de", "deu", "deut"],
    "Joshua" => ["jos", "josh"],
    "Judges" => ["judg", "judge"],
    "Ruth" => ["ru", "rut"],
    "1 Samuel" => ["1sam", "1samu", "1stsam", "1stsamu", "isam", "isamu",
                  "firstsam", "firstsamu", "1stsamuel", "isamuel", "firstsamuel"],
    "2 Samuel" => ["2sam", "2samu", "2ndsam", "2ndsamu", "iisam", "iisamu",
                  "secondsam", "secondsamu", "2ndsamuel", "iisamuel", "secondsamuel"],
    "1 Kings" => ["1kin", "1king", "1stkin", "1stking", "ikin", "iking",
                  "firstkin", "firstking", "1stkings", "ikings", "firstkings"],
    "2 Kings" => ["2kin", "2king", "2ndkin", "2ndking", "iikin", "iiking",
                  "secondkin", "secondking", "2ndkings", "iikings", "secondkings"],
    "1 Chronicles" => ["1chr", "1chro", "1chron", "1stchr", "1stchro", "1stchron",
                      "ichr", "ichro", "ichron", "firstchr", "firstchro", "firstchron",
                      "1stchronicles", "ichronicles", "firstchronicles",
                      "1stchronicle", "ichronicle", "firstchronicle"],
    "2 Chronicles" => ["2chr", "2chro", "2chron", "2ndchr", "2ndchro", "2ndchron",
                      "iichr", "iichro", "iichron", "secondchr", "secondchro", "secondchron",
                      "2ndchronicles", "iichronicles", "secondchronicles",
                      "2ndchronicle", "iichronicle", "secondchronicle"],
    "Ezra" => ["ezr"],
    "Nehemiah" => ["ne", "neh", "nehe"],
    "Esther" => ["es", "est", "esth"],
    "Job" => ["jb"],
    "Psalm" => ["ps", "psa", "psal", "psalms"],
    "Proverbs" => ["pro", "prov", "proverb"],
    "Ecclesiastes" => ["ecc", "eccl", "eccle", "ecclesiate"],
    "Song of Solomon" => ["sos", "ssol", "songs", "song", "solomon", "sol", "songsofsolomon"],
    "Isaiah" => ["isa", "isai"],
    "Jeremiah" => ["jer", "jere"],
    "Lamentations" => ["lam", "lame"],
    "Ezekiel" => ["eze", "ezek"],
    "Daniel" => ["dan", "dani"],
    "Hosea" => ["hos", "hose"],
    "Joel" => ["joe"],
    "Amos" => ["amo"],
    "Obadiah" => ["oba", "obad"],
    "Jonah" => ["jon", "jona"],
    "Micah" => ["mic", "mica"],
    "Nahum" => ["nah", "nahu"],
    "Habakkuk" => ["hab", "haba"],
    "Zephaniah" => ["zep", "zeph"],
    "Haggai" => ["hag", "hagg"],
    "Zechariah" => ["zec", "zech"],
    "Malachi" => ["mal", "mala"],
    "Matthew" => ["mat", "matt"],
    "Mark" => ["mar"],
    "Luke" => ["luk"],
    "John" => ["joh"],
    "Acts" => ["act"],
    "Romans" => ["rom", "roma"],
    "1 Corinthians" => ["1cor", "1cori", "1corin", "1stcor", "1stcori", "1stcorin",
                        "icor", "icori", "icorin", "firstcor", "firstcori", "firstcorin",
                        "1stcorinthians", "icorinthians", "firstcorinthians",
                        "1stcorinthian", "icorinthian", "firstcorinthian"],
    "2 Corinthians" => ["2cor", "2cori", "2corin", "2ndcor", "2ndcori", "2ndcorin",
                        "iicor", "iicori", "iicorin", "secondcor", "secondcori", "secondcorin",
                        "2ndcorinthians", "iicorinthians", "secondcorinthians",
                        "2ndcorinthian", "iicorinthian", "secondcorinthian"],
    "Galatians" => ["gal", "gala"],
    "Ephesians" => ["eph", "ephe"],
    "Philippians" => ["phili", "philip", "philipian"],
    "Colossians" => ["col", "colo", "colossian"],
    "1 Thessalonians" => ["1the", "1thes", "1thess", "1stthe", "1stthes", "1stthess",
                          "ithe", "ithes", "ithess", "firstthe", "firstthes", "firstthess",
                          "1stthessalonians", "ithessalonians", "firstthessalonians",
                          "1stthessalonian", "ithessalonian", "firstthessalonian"],
    "2 Thessalonians" => ["2the", "2thes", "2thess", "2ndthe", "2ndthes", "2ndthess",
                          "iithe", "iithes", "iithess", "secondthe", "secondthes", "secondthess",
                          "2ndthessalonians", "iithessalonians", "secondthessalonians",
                          "2ndthessalonian", "iithessalonian", "secondthessalonian"],
    "1 Timothy" => ["1tim", "1timo", "1sttim", "1sttimo", "itim", "itimo", "firsttim", "firsttimo",
                    "1sttimothy", "itimothy", "firsttimothy"],
    "2 Timothy" => ["2tim", "2timo", "2ndtim", "2ndtimo", "iitim", "iitimo", "secondtim", "secondtimo",
                    "2ndtimothy", "iitimothy", "secondtimothy"],
    "Titus" => ["tit", "titu"],
    "Philemon" => ["phile", "philem"],
    "Hebrews" => ["heb", "hebr"],
    "James" => ["jam", "jame"],
    "1 Peter" => ["1pet", "1pete", "1stpet", "1stpete", "ipet", "ipete", "firstpet", "firstpete",
                  "1stpeter", "ipeter", "firstpeter"],
    "2 Peter" => ["2pet", "2pete", "2ndpet", "2ndpete", "iipet", "iipete", "secondpet", "secondpete"
    ],
    "1 John" => ["1joh", "1stjoh", "ijoh", "firstjoh", "1stjohn", "ijohn", "firstjohn"],
    "2 John" => ["2joh", "2ndjoh", "iijoh", "secondjoh", "2ndjohn", "iijohn", "secondjohn"],
    "3 John" => ["3joh", "3rdjoh", "iiijoh", "thirdjoh", "3rdjohn", "iiijohn", "thirdjohn"],
    "Jude" => ["jud"],
    "Revelation" => ["rev", "reve", "revel"],
  }.freeze

  def look_up_book_name name
    possible_match = []
    BOOK_NAMES.each_pair do |key, value|
      if key.gsub(" ", "").downcase.start_with?(name) ||
          value.any?{|val| val.start_with? name}
        possible_match.push key
      end
    end
    return possible_match
  end

  def is_digit? str
    codepoints = str.codepoints
    codepoints.any? and codepoints.all?{|str| str.between? ?0.ord, ?9.ord}
  end

  def is_alphabet? str
    codepoints = str.upcase.codepoints
    codepoints.any? and codepoints.all?{|str| str.between? ?A.ord, ?Z.ord}
  end

  def is_alphanumeric? str
    str.split("").all?{|str| is_alphabet?(str) || is_digit?(str)}
  end
  
=begin
  def illegal_passage passage
    legal = /[^a-z0-9:;\-,]/i
    msg = "Only characters in [a-zA-Z0-9:;-,] are allowed but found %s"
    raise ArgumentError, msg % [passage.scan(legal)], \
      caller if passage.match? legal
  end
=end

  def illegal_book book_name
    raise ArgumentError, "book name [#{book_name}] is too short. Expects length between #{MIN_BOOK_LENGTH} and #{MAX_BOOK_LENGTH}", \
      caller if book_name.length < MIN_BOOK_LENGTH
    raise ArgumentError, "book name [#{book_name}] is too long. Expects length between #{MIN_BOOK_LENGTH} and #{MAX_BOOK_LENGTH}", \
      caller if book_name.length > MAX_BOOK_LENGTH
    legal = /[^1-3a-z]|[a-z][^a-z][a-z]/i
    msg = "Only characters in [1-3a-zA-Z] are allowed but found %s in [%s]"
    raise ArgumentError, msg % [book_name.scan(legal), book_name], \
      caller if book_name.match? legal
  end

  def illegal_chapter_verse chap_vers
    legal = /[:;,\-]{2,}|[^0-9:;\-,]/i
    msg = "Only characters in [0-9:;-,] are allowed but found %s in [%s]"
    raise ArgumentError, msg % [chap_vers.scan(legal), chap_vers], \
      caller if chap_vers.match? legal
  end

  def get_book psg
    (psg.length - 1).downto 0 do |index|
      if psg[index].match? /[a-z]/i
        res = psg[0 .. index]
        illegal_book res
        result = look_up_book_name res.downcase
        if result.length.eql? 1
          return result[0]
        else
          msg = result.empty? ? [res] : \
            "You specified [`%s']. Did you mean %s" % [res, result]
          raise ArgumentError, msg, caller
        end
      end
    end
    raise ArgumentError, "specify a valid book name", caller
  end

  def get_chapters_verses psg
    (psg.length - 1).downto 0 do |index|
      if psg[index].match? /[a-z]/i
        result = psg[index+1 .. -1]
        illegal_chapter_verse result
        return result
      end
    end
  end

  def treat_semicolon args
    if args.match? /[:\-,]/ and not is_digit? args
      args.split(?:)
    elsif is_digit? args and args.to_i > 0
      [args, ""]
    else
      raise ArgumentError, [args], caller
    end
  end
  
  def treat_colon args
    if args.length.eql? 2
      if !is_digit?(args[0]) || is_digit?(args[0]) && args[0].to_i <= 0
        raise ArgumentError, [args.join(?:)], caller
      end
      if args[1].match? /[\-,]/
        {args[0] => treat_comma(args[1].split(?,)).flatten}
      else
        {args[0] => args[1].empty? ? [] : [args[1]]}
      end
    else
      raise ArgumentError, [args.join(?:)], caller
    end
  end
  
  def treat_comma args
    args.map do |ele|
      if ele.include?(?-)
        temp = ele.split(?-)
        if temp.length.eql?(2) and
          temp.all?{|t| is_digit? t and t.to_i > 0} and
            temp[0].to_i <= temp[1].to_i
          (temp[0] .. temp[1]).to_a
        else
          raise ArgumentError, [ele], caller
        end
      elsif is_digit? ele and ele.to_i > 0
        ele
      else
        raise ArgumentError, [ele], caller
      end
    end
  end
  
  def clean_result args
    to_integer = ->(kv){[kv[0].to_i, kv[1].map(&:to_i)]}
    args.each_with_object({}) do |ele, obj|
      chap, vers = to_integer[*ele]
      if obj[chap]
        obj[chap].push *(vers - obj[chap]) # unique verses
      else
        obj[chap] = vers
      end
    end
  end
  
  public
  
  CHAPTER_PREFIX = <<-PREFIX
    <div class="cno"><span v="0">6</span></div>
  PREFIX
  
  def passagify book_chapters_verses
    book = get_book book_chapters_verses
    chaps_vers = get_chapters_verses book_chapters_verses
    {book => clean_result(
      chaps_vers.split(?;).map do |ele|
        treat_colon treat_semicolon(ele)
      end
    )}
  end
end
