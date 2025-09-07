import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notifications/domain/entities/push_message.dart';
import 'package:flutter_notifications/presentation/blocs/notifications/notifications_bloc.dart';

class DetailsScreen extends StatelessWidget {
  final String pushMessageId;

  const DetailsScreen({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) {
    
    final pushMessage = context.read<NotificationsBloc>().getMessageById(pushMessageId);

    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen')),
      body: (pushMessage != null)
          ? _DetailsView(pushMessage: pushMessage)
          : const Center(child: Text('No se encontro la notificacion')),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final PushMessage pushMessage;

  const _DetailsView({required this.pushMessage});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          if (pushMessage.imageUrl != null)
            Image.network(pushMessage.imageUrl!),
          const SizedBox(height: 30),
          Text(pushMessage.title, style: textStyles.titleMedium),
          // const SizedBox(height: 10),
          Text(pushMessage.body),
          const Divider(),
          Text(pushMessage.data.toString()),
        ],
      ),
    );
  }
}
