import 'package:flutter/material.dart';
import 'package:movies_app/browse_category.dart';
import 'package:movies_app/home_screen.dart';
import 'package:movies_app/search_tab.dart';
import 'package:movies_app/watch_list_screen.dart';

class HomeButtonBar extends StatefulWidget {
  static const routeName = "home button bar";

  @override
  State<HomeButtonBar> createState() => _HomeButtonBarState();
}

class _HomeButtonBarState extends State<HomeButtonBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xff1A1A1A),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xff1A1A1A),
          selectedItemColor: Color(0xffFFBB3B),
          unselectedItemColor: Color(0xffB5B4B4),
          currentIndex: _currentIndex,
          onTap: (index) {
            if(index==1){
              showSearch(context: context, delegate: SearchTab());
            }
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.movie_creation),
              label: 'Browse',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Watchlist',
            ),
          ],
        ),
      ),
      body: tabs[_currentIndex],
    );
  }

  List<Widget> tabs = [
    HomeScreen(),
    Container(),
    BrowseCategoriesScreen(),
    WatchListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    tabs[1] = SearchScreen(onSearchPressed: () {
      showSearch(context: context, delegate: SearchTab());
    });
  }
}

class SearchScreen extends StatelessWidget {
  static const routeName = " search";
  final VoidCallback onSearchPressed;

  const SearchScreen({required this.onSearchPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.transparent,
      body: Container(
        color: Color(0xff1A1A1A),
      )
    );
  }
}

