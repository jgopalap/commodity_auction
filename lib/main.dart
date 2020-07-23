import 'package:ceylonteaauction/src/ui/main_screen/main_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'Welcome to Flutter',
      theme: ThemeData(
          primaryTextTheme: TextTheme(headline1: TextStyle(color: Colors.black)),
          textTheme: TextTheme(
              headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.black),
              headline6: TextStyle(fontSize: 30.0, fontStyle: FontStyle.italic, color: Colors.black),
              bodyText2: TextStyle(fontSize: 20, color: Colors.black),
          )
      ),
      home: MainView()
    );
  }
}
