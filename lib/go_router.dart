import 'package:go_router/go_router.dart';
import 'package:save_money/screens/home_screen.dart';
import 'package:save_money/screens/splash_screem.dart';

final goRouter = GoRouter(
  initialLocation: "/splash",
  routes: [
    GoRoute(path: "/splash", builder: (context, state) => SplashScreen()),
    GoRoute(path: "/", builder: (context, state) => HomeScreen()),
  ],
);
