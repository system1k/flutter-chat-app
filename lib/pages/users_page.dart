import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/models/user.dart';

import 'package:chat_app/services/usuarios_services.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/socket_services.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  final usuarioService = UsuariosService();

  List<Usuario> users = [];

  @override
  void initState() {
    _refreshUsers();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthServices>(context);
    final socketService = Provider.of<SocketServices>(context);
    final user = authServices.usuario;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(user!.nombre, style: const TextStyle(color: Colors.black87)),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.black87),
          onPressed: (){
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthServices.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.online
              ? Icon(Icons.check_circle, color: Colors.blue[400])
              : const Icon(Icons. offline_bolt, color: Colors.red)
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
    users = await usuarioService.getUsuarios();
    setState(() {});
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
  
  final Usuario users;  
  const _UsersListTile(this.users);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(users.nombre),
      subtitle: Text(users.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(users.nombre.substring(0,2))
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