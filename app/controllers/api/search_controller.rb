class API::SearchController < API::ApplicationController
  def show
    # TODO: Implement this method
    # Traverse the database and return the link to bible passage
    render json: {
      search: {option: params[:id]},
      data: [
        {
          book_id: 1, book_name: "Genesis",
          chapter_id: 120, chapter: 1, 
          verse_id: 1200, verse: 5
        },
        {
          book_id: 66, book_name: "Revelation",
          chapter_id: 1220, chapter: 10,
          verse_id: 12229, verse: 10
        }
      ]
    }
  end
end