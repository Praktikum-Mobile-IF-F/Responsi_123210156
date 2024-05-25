import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/jenis_kopi.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<JenisKopi> _jenisKopiList = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchJenisKopi();
  }

  Future<void> _fetchJenisKopi() async {
    final response = await http.get(Uri.parse('https://fake-coffee-api.vercel.app/api'));
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      setState(() {
        _jenisKopiList = json.map((e) => JenisKopi.fromJson(e)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredKopiList = _jenisKopiList.where((kopi) {
      return kopi.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredKopiList.length,
        itemBuilder: (context, index) {
          final kopi = filteredKopiList[index];
          return ListTile(
            leading: Image.network(kopi.imageUrl ?? ''),
            title: Text(kopi.name ?? ''),
            subtitle: Text(kopi.description ?? ''),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: kopi,
              );
            },
          );
        },
      ),
    );
  }
}
