import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_app/models/user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  
  final List users = [
    User(uid: 1, name: 'Delving', email: 'test1@test.com', online: true),
    User(uid: 2, name: 'Berling', email: 'test2@test.com', online: false),
    User(uid: 3, name: 'Kerling', email: 'test3@test.com', online: true)
  ]; 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mí nombre', style: TextStyle(color: Colors.black87)),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.black87),
          onPressed: (){},
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.blue[400]),
            //child: const Icon(Icons. offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _refreshUsers,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400]),
          waterDropColor: Colors.blue[400]!,
        ),
        child: _UsersListView(users)
      )
    );
  }

  _refreshUsers() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();    
  }
}

class _UsersListView extends StatelessWidget {
  
  final List users;
  const _UsersListView(this.users);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (_, i) => _UsersListTile(users[i]), 
      separatorBuilder: (_, i) => const Divider()
    );
  }
}

class _UsersListTile extends StatelessWidget {
  
  final User users;  
  const _UsersListTile(this.users);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(users.name),
      subtitle: Text(users.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(users.name.substring(0,2))
      ),
      trailing: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: users.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(100)
        ),
      ),
    );
  }

}