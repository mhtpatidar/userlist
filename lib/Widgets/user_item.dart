import 'package:flutter/material.dart';
import '../Models/User.dart';
import '../Views/user_detail_screen.dart';

class UserItem extends StatelessWidget {
  final User user;

  UserItem({required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailScreen(user: user),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(user.pictureUrl),
                radius: 30.0,
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        Text(
                          user.registrationDate.toLocal().toString().split(' ')[0],
                          style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      user.email,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      user.country,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
