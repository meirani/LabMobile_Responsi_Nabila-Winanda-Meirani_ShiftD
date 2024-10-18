import 'dart:convert';
import 'package:responsi_satu/helpers/api.dart';
import 'package:responsi_satu/helpers/api_url.dart';
import 'package:responsi_satu/model/genre.dart';

class GenreBloc {
  static Future<List<Genre>> getGenres() async {
    String apiUrl = ApiUrl.listGenre;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listGenre = (jsonObj as Map<String, dynamic>)['data'];
    List<Genre> Genres = [];
    for (int i = 0; i < listGenre.length; i++) {
      Genres.add(Genre.fromJson(listGenre[i]));
    }
    return Genres;
  }

  static Future addGenre({Genre? Genre}) async {
    String apiUrl = ApiUrl.createGenre;
    var body = {
      "book_title": Genre!.book_title,
      "book_genre": Genre.book_genre,
      "cover_type": Genre.cover_type.toString()
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updateGenre({required Genre Genre}) async {
    String apiUrl = ApiUrl.updateGenre(int.parse(Genre.id! as String));
    print(apiUrl);
    var body = {
      "book_title": Genre.book_title,
      "book_genre": Genre.book_genre,
      "cover_type": Genre.cover_type.toString()
    };
    print("Body : $body");
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deleteGenre({int? id}) async {
    String apiUrl = ApiUrl.deleteGenre(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}
