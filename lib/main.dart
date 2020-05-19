import 'package:flutter/material.dart';
import 'screens/home.dart';


main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFC6C6C6),
        accentColor: Colors.amber,
        fontFamily: 'BalooChettan2',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.dark().textTheme.copyWith(
            title: TextStyle(
              fontSize: 20,
              fontFamily: 'Kalam',
              color: Colors.grey[800]
            )
          )
        )
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
