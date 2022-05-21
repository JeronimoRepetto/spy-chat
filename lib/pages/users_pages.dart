import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:spy_chat/services/auth_service.dart';
import 'package:spy_chat/services/chat_service.dart';
import 'package:spy_chat/services/users_servie.dart';

import '../models/user.dart';
import '../services/socket_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final userService = UserService();

  List<User> users = [];

  @override
  void initState() {
      _searchUser();
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final user = authService.user;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(user!.name.toString(),
            style: TextStyle(color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.logout_outlined, color: Colors.black87),
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  )
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
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
        backgroundColor: Colors.blue[100],
        child: Text(user.name!.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: user.online! ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: (){
        final chatService = Provider.of<ChatService>(context,listen: false);
        chatService.userToSend = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _searchUser() async {
    users = (await userService.getUsers())!;
    _refreshController.refreshCompleted();
    setState(() {});
  }
}
