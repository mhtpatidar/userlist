// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userlist/Views/SplashScreen.dart';
import 'Bloc/user_bloc.dart';
import 'Db/database_helper.dart';
import 'Views/user_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(databaseHelper: DatabaseHelper()),
      child: MaterialApp(
        title: 'User List App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
