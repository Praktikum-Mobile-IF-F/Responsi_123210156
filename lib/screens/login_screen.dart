import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameOrEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');
    final savedEmail = prefs.getString('email');
    final inputUsernameOrEmail = _usernameOrEmailController.text;
    final inputPassword = _passwordController.text;

    if (inputUsernameOrEmail.isEmpty || inputPassword.isEmpty) {
      _showErrorDialog(context, 'Please fill in all fields');
    } else if (savedUsername == null || savedPassword == null || savedEmail == null) {
      _showErrorDialog(context, 'No account found. Please register first.');
    } else if ((inputUsernameOrEmail == savedUsername || inputUsernameOrEmail == savedEmail) && inputPassword == savedPassword) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showErrorDialog(context, 'Invalid username/email or password');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameOrEmailController,
              decoration: InputDecoration(labelText: 'Username or Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
