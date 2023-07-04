
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  MovieDetailsScreen({required this.movieId});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  Map<String, dynamic> movieDetails = {};
  List<dynamic> similarMovies = [];

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
    fetchSimilarMovies();
  }

  Future<void> fetchMovieDetails() async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/${widget.movieId}?api_key=0a5c3df5105c20404b474a3e93ab8f65'),
    );

    if (response.statusCode == 200) {
      setState(() {
        movieDetails = json.decode(response.body);
      });
    } else {
    }
  }

  Future<void> fetchSimilarMovies() async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/${widget.movieId}/similar?api_key=0a5c3df5105c20404b474a3e93ab8f65'),
    );

    if (response.statusCode == 200) {
      setState(() {
        final data = json.decode(response.body);
        similarMovies = data['results'];
      });
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    if (movieDetails.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1A1A1A),
        title: Text(movieDetails['title'] ?? ''),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Trailer Section
            Container(
              color: Color(0xff1A1A1A),
              width: double.infinity,
              height: 250,
              child: Stack(
                children: [
                  Image.network(
                    'https://image.tmdb.org/t/p/w500${movieDetails['backdrop_path'] ?? ''}',
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(

                      child: Icon(
                        Icons.play_circle,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),


            // Movie Details Section
            Container(
              color: Color(0xff1A1A1A),
              child: Padding(

                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movieDetails['title'] ?? '',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
                      color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Release Date: ${movieDetails['release_date'] ?? ''}',
                      style: TextStyle(fontSize: 16,color: Colors.white),

                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w200${movieDetails['poster_path'] ?? ''}',
                            width: 129,
                            height: 199,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Genres:',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: [
                                  for (var genre in movieDetails['genres'] ?? [])
                                    Chip(
                                      label: Text(genre['name'] ?? '',),
                                    ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Overview:',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Colors.white),
                              ),

                              SizedBox(height: 8),
                              Text(
                                movieDetails['overview'] ?? '',
                                style: TextStyle(fontSize: 13,color: Colors.white),
                              ),
                              SizedBox(height: 8),

                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.yellow),
                                  SizedBox(width: 8),
                                  Text(
                                    '${movieDetails['vote_average'] ?? ''}',
                                    style: TextStyle(fontSize: 16,color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // More Like This Section
            Container(
              color:  Color(0xff282A28),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'More Like This',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: similarMovies.length,
                        itemBuilder: (ctx, index) {
                          final movie = similarMovies[index];
                          return GestureDetector(
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
                              width: 150,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${movie['poster_path'] ?? ''}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
