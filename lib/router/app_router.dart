import 'package:go_router/go_router.dart';
import 'package:kybank/screens/home_screens/home_screen.dart';
import 'package:kybank/screens/login_screens/login_screen.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
