import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  Future<Map<String, String?>> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final email = prefs.getString('email');
    final dob = prefs.getString('dob');
    return {
      'username': username,
      'email': email,
      'dob': dob,
    };
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Menghapus semua informasi pengguna yang disimpan
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); // Kembali ke layar login dan hapus semua rute lainnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: _loadProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat profil'));
          } else {
            final profile = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username: ${profile?['username'] ?? ''}'),
                  Text('Email: ${profile?['email'] ?? ''}'),
                  Text('Tanggal Lahir: ${profile?['dob'] ?? ''}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
