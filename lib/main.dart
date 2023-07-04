import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/browse_category.dart';
import 'package:movies_app/home.dart';
import 'package:movies_app/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movies_app/watch_list_screen.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings =
      Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  await FirebaseFirestore.instance.disableNetwork();
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      routes: {
        HomeButtonBar.routeName:(context)=>HomeButtonBar(),
        HomeScreen.routeName: (context)=>HomeScreen(),
        BrowseCategoriesScreen.routeName: (ctx) => BrowseCategoriesScreen(),
        WatchListScreen.routeName: (ctx) => WatchListScreen(),
      },
      initialRoute: HomeButtonBar.routeName,
    );
  }
}