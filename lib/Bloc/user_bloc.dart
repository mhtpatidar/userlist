import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:userlist/Bloc/user_event.dart';
import 'package:userlist/Bloc/user_state.dart';

import '../Db/database_helper.dart';
import '../Models/User.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final DatabaseHelper databaseHelper;
  int _resultCount = 10; // Track the number of results
  bool _isFetchingMore = false; // To prevent multiple fetches at the same time

  UserBloc({required this.databaseHelper}) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<FetchMoreUsers>(_onFetchMoreUsers); // Handle fetching more users
  }

  void _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    _resultCount = 10; // Reset the result count when fetching users initially
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection, load users from database
      final users = await databaseHelper.getUsers();
      if (users.isNotEmpty) {
        emit(UserLoaded(users));
      } else {
        emit(UserError('No internet connection and no users found in the database.'));
      }
    } else {
      // Internet connection available, fetch users from API
      try {
        final response = await http.get(Uri.parse('https://randomuser.me/api/?results=$_resultCount'));
        if (response.statusCode == 200) {
          List<dynamic> userJson = json.decode(response.body)['results'];
          List<User> users = userJson.map((json) => User.fromJson(json)).toList();
          for (User user in users) {
            await databaseHelper.insertUser(user);
          }
          emit(UserLoaded(users));
        } else {
          emit(UserError('Failed to load users'));
        }
      } catch (e) {
        emit(UserError('Failed to load users: $e'));
      }
    }
  }

  void _onFetchMoreUsers(FetchMoreUsers event, Emitter<UserState> emit) async {
    if (state is UserLoaded && !_isFetchingMore) {
      _isFetchingMore = true;
      try {
        final currentUsers = (state as UserLoaded).users;
        final connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          // No internet connection, do not fetch more users
          emit(UserError('No internet connection.'));
        } else {
          final response = await http.get(Uri.parse('https://randomuser.me/api/?results=10&seed=foobar&page=${(_resultCount ~/ 10) + 1}'));
          if (response.statusCode == 200) {
            List<dynamic> userJson = json.decode(response.body)['results'];
            List<User> newUsers = userJson.map((json) => User.fromJson(json)).toList();
            for (User user in newUsers) {
              await databaseHelper.insertUser(user);
            }
            emit(UserLoaded(currentUsers + newUsers));
            _resultCount += 10;
          } else {
            emit(UserError('Failed to load more users'));
          }
        }
      } catch (e) {
        emit(UserError('Failed to load more users: $e'));
      } finally {
        _isFetchingMore = false;
      }
    }
  }
}
