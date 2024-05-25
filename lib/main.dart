import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/profile_screen.dart';
import 'models/jenis_kopi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Shop App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => MainScreen(),
        '/profile': (context) => ProfileScreen(),
        '/detail': (context) => DetailScreen(
          jenisKopi: ModalRoute.of(context)!.settings.arguments as JenisKopi,
        ),
      },
    );
  }
}
