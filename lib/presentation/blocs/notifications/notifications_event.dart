part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();
}

class NotificationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  const NotificationStatusChanged(this.status);

  @override
  List<Object> get props => [status];
}

//evento para nueva notificacion
class NotificationReceived extends NotificationsEvent {
  final PushMessage message;

  const NotificationReceived(this.message);

  @override
  List<Object> get props => [message];
}

//todo agregar evento para nueva notificacion
