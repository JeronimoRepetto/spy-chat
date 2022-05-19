import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:spy_chat/services/auth_service.dart';

import '../models/user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final users = [
    User(
        email: 'jeronimorepetto@gmail.com',
        name: 'Jeronimo',
        online: true,
        uid: '1'),
    User(
        email: 'jeronimorepetto1@gmail.com',
        name: 'Mariel',
        online: true,
        uid: '2'),
    User(
        email: 'jeronimorepetto2@gmail.com',
        name: 'Raul',
        online: true,
        uid: '3'),
    User(
        email: 'jeronimorepetto3@gmail.com',
        name: 'Maria',
        online: false,
        uid: '4'),
  ];
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.user;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(user!.name.toString(), style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.logout_outlined, color: Colors.black87),
          onPressed: () {
            //TODO DESCONECT SOCKET SERVER
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.check_circle,
              color: Colors.blue,
            ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropHeader(
            complete: Icon(
              Icons.check_circle,
              color: Colors.blue[400],
            ),
            waterDropColor: Color(0xFF42A5F5)),
        onRefresh: _searchUser,
        child: _userListView(),
      ),
    );
  }

  ListView _userListView() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) => _userTile(users[index]),
        separatorBuilder: (_, index) => const Divider(),
        itemCount: users.length);
  }

  ListTile _userTile(User user) {
    return ListTile(
      title: Text(user.name!),
      subtitle: Text(user.email!),
      leading: CircleAvatar(
        child: Text(user.name!.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online! ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
    );
  }

  _searchUser() async{
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
