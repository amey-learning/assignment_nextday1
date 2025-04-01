import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;

import '../model/usermodel.dart';
import 'favourite_user_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> _users = [];
  Set<int> _favoriteUsers = {};

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _loadFavorites();
  }

  Future<void> _fetchUsers() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _users = (data['data'] as List).map((json) => User.fromJson(json)).toList();
      });
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteUsers = (prefs.getStringList('favorites') ?? []).map((id) => int.parse(id)).toSet();
    });
  }

  Future<void> _toggleFavorite(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteUsers.contains(userId)) {
        _favoriteUsers.remove(userId);
      } else {
        _favoriteUsers.add(userId);
      }
      prefs.setStringList('favorites', _favoriteUsers.map((id) => id.toString()).toList());
    });
  }

  void _showFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoriteUsersScreen(favoriteUsers: _users.where((user) => _favoriteUsers.contains(user.id)).toList()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: _showFavorites,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          final isFavorite = _favoriteUsers.contains(user.id);
          return Card(
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
              title: Text('${user.firstName} ${user.lastName}'),
              trailing: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () => _toggleFavorite(user.id),
              ),
            ),
          );
        },
      ),
    );
  }
}


