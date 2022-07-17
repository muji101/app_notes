import 'package:app_notes/providers/notes.dart';
import 'package:app_notes/screens/add_or_detail_screen.dart';
import 'package:app_notes/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Notes(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        home: HomeScreen(),
        routes: {
          AddOrDetailScreen.routeName: (context) => AddOrDetailScreen(),
        },
      ),
    );
  }
}
