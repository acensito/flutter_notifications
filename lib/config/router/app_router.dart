import 'package:flutter_notifications/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen()
    ),
    GoRoute(
      path: '/push-details/:pushMessageId',
      builder: (context, state) => DetailsScreen(pushMessageId: state.pathParameters['pushMessageId'] ?? ''),
    ),
  ],
);
