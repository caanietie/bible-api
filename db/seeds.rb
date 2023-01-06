SQLite3::Database.open "db/seeds.db" do |db|
  stmt_book = "SELECT bookID, bookName FROM bookNames"
  db.execute stmt_book do |num, bookName|
    book = Book.new name: bookName.strip
    book.save
    print "#{book.name}"
    stmt_chapter = "SELECT chapter, info FROM chapters WHERE bookNum IS #{num}"
    db.execute stmt_chapter do |chapter, info|
      chap = book.chapters.build chapter: chapter, info_html: info.strip
      chap.save
      print " #{chapter}"
      stmt_verse = "SELECT verse, info FROM verses WHERE bookNum IS #{num} AND chapter IS #{chapter}"
      info_html = info.scan %r[<div class="v" id="\d{1,3}">.*?</div>]
      db.execute stmt_verse do |verse, info|
        vers = chap.verses.build book_id: book.id, verse: verse, info_text: info.strip, info_html: info_html[verse - 1].strip
        vers.save
      end
    end
    puts
  end
end
