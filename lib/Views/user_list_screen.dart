import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Bloc/user_bloc.dart';
import '../Bloc/user_event.dart';
import '../Bloc/user_state.dart';
import '../Widgets/user_item.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late UserBloc _userBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _userBloc = context.read<UserBloc>();
    _userBloc.add(FetchUsers());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _userBloc.add(FetchMoreUsers());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserInitial || state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            final users = state.users;
            return ListView.builder(
              controller: _scrollController,
              itemCount: users.length + 1, // Add 1 for the loading indicator
              itemBuilder: (context, index) {
                if (index == users.length) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final user = users[index];
                  return UserItem(user: user);
                }
              },
            );
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
