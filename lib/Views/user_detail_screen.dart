import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Models/User.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  UserDetailScreen({required this.user});

  int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final age = calculateAge(user.dob);

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 290, // Adjust width as needed
                height: 180, // Adjust height as needed
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(user.pictureUrl),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),

            Divider(height: 2,color: Colors.black,),

            SizedBox(height: 10.0),
            Row(
              children: [
                Text(
                  'Email: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Text(user.email, style: TextStyle(fontSize: 16.0)),
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                Text(
                  'Date Joined:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Text(
                  ' ${calculateDateDifference(user.registrationDate)}',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              children: [
                Text(
                  'Date of Birth:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Text(' ${DateFormat.yMMMd().format(user.dob)}', style: TextStyle(fontSize: 16.0)),
              ],
            ),
            SizedBox(height: 25.0),

            Text(
              'LOCATION:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Divider(height: 2,color: Colors.black,),
            Text(
              'City: ${user.city}\nState: ${user.state}\nCountry: ${user.country}\nPostcode: ${user.postcode}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  String calculateDateDifference(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
