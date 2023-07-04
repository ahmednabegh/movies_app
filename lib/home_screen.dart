import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "home screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> popularMovies = [];
  List<dynamic> latestMovies = [];
  List<dynamic> topRatedMovies = [];
  List<bool> isBookmarkedList = [];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchPopularMovies();
    fetchLatestMovies();
    fetchTopRatedMovies();
  }

  Future<void> fetchPopularMovies() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=0a5c3df5105c20404b474a3e93ab8f65'),
    );

    if (response.statusCode == 200) {
      setState(() {
        final data = json.decode(response.body);
        popularMovies = data['results'];
        isBookmarkedList = List<bool>.filled(popularMovies.length, false);
      });
    } else {

    }
  }

  Future<void> fetchLatestMovies() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/now_playing?api_key=0a5c3df5105c20404b474a3e93ab8f65'),
    );

    if (response.statusCode == 200) {
      setState(() {
        final data = json.decode(response.body);
        latestMovies = data['results'];
      });
    } else {
      // Handle error
    }
  }

  Future<void> fetchTopRatedMovies() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/top_rated?api_key=0a5c3df5105c20404b474a3e93ab8f65'),
    );

    if (response.statusCode == 200) {
      setState(() {
        final data = json.decode(response.body);
        topRatedMovies = data['results'];
      });
    } else {
    }
  }

  Widget buildSection(String sectionName, List<dynamic> movies) {
    return Container(
      color: Color(0xff282A28),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (ctx, index) {
                if (index >= isBookmarkedList.length)
                  return Container();

                final movie = movies[index];
                final isBookmarked = isBookmarkedList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailsScreen(movieId: movie['id']),
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Image.network(
                                'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                                fit: BoxFit.cover,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.bookmark_add,
                                    size: 50,
                                  ),
                                  color: isBookmarked
                                      ? Colors.yellow
                                      : Color(0xffB5B4B4),
                                  onPressed: () {
                                    saveMovieToWatchList(movie, index);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          movie['title'],
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveMovieToWatchList(
      Map<String, dynamic> movie, int index) async {
    if (index >= isBookmarkedList.length) return;

    final isBookmarked = isBookmarkedList[index];
    setState(() {
      isBookmarkedList[index] =
          !isBookmarked;
    });
    try {
      await FirebaseFirestore.instance.collection('watchlist').add(movie);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Movie added to watchlist'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add movie to watchlist'),
        ),
      );
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String coverPhotoUrl = popularMovies.isNotEmpty
        ? 'https://image.tmdb.org/t/p/original${popularMovies[0]['backdrop_path']}'
        : 'https://example.com/placeholder.jpg';

    return Scaffold(
      backgroundColor: Color(0xff121312),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(coverPhotoUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.play_circle_fill,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 35),

            // Popular Movies Section
            buildSection('Popular Movies', popularMovies),
            SizedBox(height: 35),

            // Latest Movies Section
            buildSection('Latest Movies', latestMovies),
            SizedBox(height: 35),

            // Top Rated Movies Section
            buildSection('Top Rated Movies', topRatedMovies),
          ],
        ),
      ),
    );
  }
}
