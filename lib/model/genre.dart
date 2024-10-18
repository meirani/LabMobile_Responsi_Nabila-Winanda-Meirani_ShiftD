class Genre {
  int? id;
  String? book_title;
  String? book_genre;
  String? cover_type;

  Genre({this.id, this.book_title, this.book_genre, this.cover_type});

  factory Genre.fromJson(Map<String, dynamic> obj) {
    return Genre(
        id: obj['id'],
        book_title: obj['book_title'],
        book_genre: obj['book_genre'],
        cover_type: obj['cover_type']);
  }
}
