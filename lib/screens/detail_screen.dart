import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/jenis_kopi.dart';

class DetailScreen extends StatefulWidget {
  final JenisKopi jenisKopi;

  DetailScreen({required this.jenisKopi});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Database database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
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

  Future<void> _addToFavorites(BuildContext context, JenisKopi kopi) async {
    await database.insert(
      'favorites',
      kopi.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _removeFromFavorites(String id) async {
    await database.delete(
      'favorites',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Widget _buildTextWithBoldTitle(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.0),
        content.contains(',')
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content.split(',').map((item) {
            return Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(item.trim()),
            );
          }).toList(),
        )
            : Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(content.trim()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final kopi = widget.jenisKopi;
    return Scaffold(
      appBar: AppBar(
        title: Text(kopi.name ?? 'Detail Kopi'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () async {
              await _addToFavorites(context, kopi);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200, // Set a fixed height for the image
                child: Image.network(
                  kopi.imageUrl ?? '',
                  fit: BoxFit.cover, // Ensure the image covers the container
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                kopi.name ?? '',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              _buildTextWithBoldTitle('Description', kopi.description ?? ''),
              _buildTextWithBoldTitle('Region', kopi.region ?? ''),
              _buildTextWithBoldTitle('Price', '\$${kopi.price?.toStringAsFixed(2) ?? ''}'),
              _buildTextWithBoldTitle('Weight', kopi.weight?.toString() ?? ''),
              _buildTextWithBoldTitle('Flavor Profile', kopi.flavorProfile?.join(", ") ?? ''),
              _buildTextWithBoldTitle('Grind Options', kopi.grindOption?.join(", ") ?? ''),
              _buildTextWithBoldTitle('Roast Level', kopi.roastLevel?.toString() ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}
