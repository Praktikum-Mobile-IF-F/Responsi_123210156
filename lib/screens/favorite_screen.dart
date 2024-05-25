import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/jenis_kopi.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Database database;
  List<JenisKopi> _favorites = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _fetchFavorites();
  }

  Future<void> _initDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'favorites.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE favorites(id TEXT PRIMARY KEY, name TEXT, description TEXT, price REAL, region TEXT, weight INTEGER, flavorProfile TEXT, grindOption TEXT, roastLevel INTEGER, imageUrl TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> _fetchFavorites() async {
    final List<Map<String, dynamic>> maps = await database.query('favorites');
    setState(() {
      _favorites = List.generate(maps.length, (i) {
        return JenisKopi.fromJson(maps[i]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite')),
      body: ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final kopi = _favorites[index];
          return ListTile(
            leading: Image.network(kopi.imageUrl ?? ''),
            title: Text(kopi.name ?? ''),
            subtitle: Text(kopi.description ?? ''),
          );
        },
      ),
    );
  }
}
