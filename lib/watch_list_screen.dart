import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class WatchListScreen extends StatefulWidget {
  static const routeName = " watchlist";

  @override
  _WatchListScreenState createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> watchList = [];

  @override
  void initState() {
    super.initState();
    fetchWatchList();
  }

  Future<void> fetchWatchList() async {
    final snapshot = await firestore.collection('watchlist').get();
    setState(() {
      watchList = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1A1A1A),
        title: Text('Watch List'),
      ),
      body:
      ListView.builder(
        itemCount: watchList.length,
        itemBuilder: (ctx, index) {
          final movie = watchList[index].data() as Map<String, dynamic>?;

          if (movie != null) {
            return Container(
              color: Color(0xff1A1A1A),
              child: ListTile(
                title: Text(movie['title'] ?? '',style: TextStyle(
                  color: Colors.white
                ),),
                subtitle: Text(movie['overview'] ?? '',
                  style: TextStyle(
                      color: Colors.white
                  ),
                maxLines: 1,
                  overflow: TextOverflow.ellipsis,),
                leading: Image.network(
                  'https://image.tmdb.org/t/p/w200${movie['poster_path'] ?? ''}',
                  fit: BoxFit.cover,
                  width: 130,
                  height: 180,
                ),
              ),
            );
          } else {
            return ListTile(
              title: Text('Error'),
              subtitle: Text('Invalid movie data'),
            );
          }
        },
      ),

    );
  }
}
