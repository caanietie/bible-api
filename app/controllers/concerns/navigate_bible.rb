module NavigateBible
  def next_chapter current_book, current_chapter
    next_chap = current_chapter + 1
    return {book: current_book, chapter: next_chap, verse: 1} if next_chap.exist?
    next_book = current_book + 1
    next_book = 1 unless next_book.exist?
    return {book: next_book, chapter: 1, verse: 1}
  end

  def previous_chapter current_book, current_chapter
    prev_chap = current_chapter - 1
    return {book: current_book, chapter: prev_chap, verse: 1} if prev_chap.exist?
    prev_book = current_book - 1
    prev_book = 1 unless prev_book.exist?
    return {book: prev_book, chapter: 1, verse: 1}
  end

  def next_verse current_book, current_chapter, current_verse
    next_vers = current_verse + 1
    return {book: current_book, chapter: current_chapter, verse: next_vers} if next_vers.exist?
    next_chap = current_chapter + 1
    return {book: current_book, chapter: next_chap, verse: 1} if next_chap.exist?
    next_book = current_book + 1
    next_book = 1 unless next_book.exist?
    return {book: next_book, chapter: 1, verse: 1}
  end

  def previous_verse current_book, current_chapter, current_verse
    next_vers = current_verse + 1
    return {book: current_book, chapter: current_chapter, verse: next_vers} if next_vers.exist?
    next_chap = current_chapter + 1
    return {book: current_book, chapter: next_chap, verse: 1} if next_chap.exist?
    next_book = current_book + 1
    next_book = 1 unless next_book.exist?
    return {book: next_book, chapter: 1, verse: 1}
  end
end
