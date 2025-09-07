import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notifications/domain/entities/push_message.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

// Must be a top-level function
// metodo que maneja los mensajes en background con la app cerrada
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    // Evento para cambios en el estado de los permisos
    on<NotificationStatusChanged>(_notificationStatusChanged);
    // evento para nueva notificacion
    on<NotificationReceived>(_onPushMessageReceived);

    // Corre en microtask para no romper el constructor
    Future.microtask(() async {
      await _initialStatusCheck();
      _onForegroundMessageListener();
    });
  }

  Future<void> requestPermission() async {
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  void _notificationStatusChanged(NotificationStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(status: event.status));
    _getFCMToken();
  }

  Future<void> _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  Future<void> _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;
    // final token = await messaging.getToken();
  }

  void _handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;
    final notification = PushMessage(
      messageId: message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sendDate: message.sentTime ?? DateTime.now(),
      imageUrl: message.data['image'] ?? message.notification!.android?.imageUrl ?? message.notification!.apple?.imageUrl,
    );
    add(NotificationReceived(notification));
  }

  void _onForegroundMessageListener() {
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
  }

  void _onPushMessageReceived(NotificationReceived event, Emitter<NotificationsState> emit) {
    final updatedNotifications = [event.message, ...state.notifications];
    emit(state.copyWith(notifications: updatedNotifications));
  }
}
