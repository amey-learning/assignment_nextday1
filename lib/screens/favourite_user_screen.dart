import 'package:flutter/material.dart';

import '../model/usermodel.dart';
class FavoriteUsersScreen extends StatelessWidget {
  final List<User> favoriteUsers;

  FavoriteUsersScreen({required this.favoriteUsers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Users')),
      body: favoriteUsers.isEmpty
          ? Center(child: Text('No favorites added'))
          : ListView.builder(
        itemCount: favoriteUsers.length,
        itemBuilder: (context, index) {
          final user = favoriteUsers[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
              title: Text('${user.firstName} ${user.lastName}'),
            ),
          );
        },
      ),
    );
  }
}