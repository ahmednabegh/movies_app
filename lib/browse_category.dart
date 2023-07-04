import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/movie_detail_screen.dart';
import 'dart:convert';


class BrowseCategoriesScreen extends StatefulWidget {
  static const routeName = " browse";

  @override
  _BrowseCategoriesScreenState createState() => _BrowseCategoriesScreenState();
}

class _BrowseCategoriesScreenState extends State<BrowseCategoriesScreen> {
  List<dynamic> categories = [];
  List<dynamic> genres = [];
  List<dynamic> movies = [];

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  Future<void> fetchGenres() async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/genre/movie/list?api_key=0a5c3df5105c20404b474a3e93ab8f65'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        genres = data['genres'];
      });
    } else {
      print('Failed to fetch genres');
    }
  }

  Future<void> fetchMoviesByGenre(int genreId) async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/discover/movie?api_key=0a5c3df5105c20404b474a3e93ab8f65&with_genres=$genreId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        movies = data['results'];
      });
    } else {
      print('Failed to fetch movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1A1A1A),
      appBar: AppBar(
        backgroundColor: Color(0xff1A1A1A),
        title: Text(
          'Browse category',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              itemCount: genres.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
              ),
              itemBuilder: (BuildContext context, int index) {
                final genre = genres[index];
                return GestureDetector(
                  onTap: () {
                    fetchMoviesByGenre(genre['id']);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        genre['name'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: (movies.length / 2).ceil(),
              itemBuilder: (BuildContext context, int index) {
                final int startIndex = index * 2;
                final int endIndex = startIndex + 1;
                final List<dynamic> moviePair = movies.sublist(startIndex, endIndex + 1);
                return Row(
                  children: moviePair.map((movie) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsScreen(
                                movieId: movie['id'],
                              ),
                            ),
                          );

                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Column(
                            children: [
                              Image.network(
                                'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                                width: 150,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                movie['title'],
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
