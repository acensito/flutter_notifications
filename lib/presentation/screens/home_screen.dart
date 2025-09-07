import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notifications/presentation/blocs/notifications/notifications_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select((NotificationsBloc bloc) => Text( '${bloc.state.status}')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // accion para modificar permisos
              context.read<NotificationsBloc>().requestPermission();
            },
          ),
        ],
      ),
      body: const _HomeView()
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {

    final notifications = context.watch<NotificationsBloc>().state.notifications;

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(notifications[index].title),
          subtitle: Text(notifications[index].body),
          leading: notifications[index].imageUrl != null
              ? Image.network(notifications[index].imageUrl!)
              : null,
        );
      },
    );
  }
}