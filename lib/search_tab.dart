import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movies_app/movie_detail_screen.dart';

class SearchTab extends SearchDelegate {
  static const routeName = "searchTab";

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      backgroundColor: Colors.black,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => showResults(context),
        icon: Icon(
          Icons.search,
          size: 25,
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(
        Icons.close,
        size: 25,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchMovieResults(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (ctx, index) {
              final result = results[index];
              return ListTile(
                title: Text(
                  result['title'],
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  result['overview'],
                  style: TextStyle(color: Colors.white),
                ),
                leading: Image.network(
                  'https://image.tmdb.org/t/p/w200${result['poster_path']}',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsScreen(
                        movieId: result['id'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: TextStyle(color: Colors.white),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Color(0xff1A1A1A),
      child: FutureBuilder<List<dynamic>>(
        future: fetchMovieSuggestions(query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final suggestions = snapshot.data!;
            return ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (ctx, index) {
                final suggestion = suggestions[index];
                return ListTile(
                  title: Text(
                    suggestion['title'],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    suggestion['overview'],
                    style: TextStyle(color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: Image.network(
                    'https://image.tmdb.org/t/p/w200${suggestion['poster_path']}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsScreen(
                          movieId: suggestion['id'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.white),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<List<dynamic>> fetchMovieResults(String query) async {
    final apiKey = '0a5c3df5105c20404b474a3e93ab8f65';
    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];
      return results;
    } else {
      throw Exception('Failed to fetch movie results');
    }
  }


  Future<List<dynamic>> fetchMovieSuggestions(String query) async {
    final apiKey = '0a5c3df5105c20404b474a3e93ab8f65';
    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];
      return results;
    } else {
      throw Exception('Failed to fetch movie suggestions');
    }
  }
}
