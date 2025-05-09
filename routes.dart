import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_signup/planner_screen.dart';
import 'package:login_signup/screens/authentication/login_screen.dart';
import 'package:login_signup/screens/authentication/register_screen.dart';
import 'package:login_signup/screens/dashboard/dashboard.dart';
import 'package:login_signup/screens/dashboard/profile_screen.dart';
import 'package:login_signup/screens/favorties/favorties_screen.dart';
import 'package:login_signup/screens/lines/lines_screen.dart';
import 'package:login_signup/screens/private_tab_screen.dart';
import 'package:login_signup/screens/root/root_screen.dart';
import 'package:login_signup/screens/splash/splash_screen.dart';
import 'package:login_signup/screens/tickets/tickets_screen.dart';
import 'package:login_signup/screens/maps/map_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

class Routes {
  static const String initialRoute = '/';
  static const String onBoardingRoute = '/on_boarding';
  static const String onRegisterRoute = '/register_screen';
  static const String onLoginRoute = '/login_screen';
  static const String onDashboard = '/dashboard_screen';
  static const String onProfileScreen = '/profile_screen';
  static const String onLinesScreen = '/lines_screen';
  static const String onTicketsScreen = '/tickets_screen';
  static const String onFavoritesScreen = '/favorites_screen';
  static const String onMapScreen = '/map_screen';
  static const String privateTab = '/private-tab';
  static const String onPlanner = '/planner_screen'; 
}

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => ErrorView(
    errorDetails: state.error.toString(),
  ),
  initialLocation: Routes.initialRoute,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/register_screen',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/login_screen',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/profile_screen',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/private-tab',
      builder: (context, state) => const PrivateTabScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return RootScreen(state: state, widget: child);
      },
      routes: [
        GoRoute(
          path: Routes.onDashboard,
          builder: (BuildContext context, GoRouterState state) {
            return const DashboardScreen();
          },
        ),
        GoRoute(
          path: Routes.onLinesScreen,
          builder: (BuildContext context, GoRouterState state) {
            return const LinesScreen();
          },
        ),
        GoRoute(
          path: Routes.onTicketsScreen,
          builder: (BuildContext context, GoRouterState state) {
            return const TicketScreen();
          },
        ),
        GoRoute(
          path: Routes.onFavoritesScreen,
          builder: (BuildContext context, GoRouterState state) {
            return const FavorScreen();
          },
        ),
        GoRoute(
          path: Routes.onPlanner,
          builder: (BuildContext context, GoRouterState state) {
            return const RoutePlannerPageState();
          },
        ),
        GoRoute(
          path: Routes.onMapScreen, 
          builder: (BuildContext context, GoRouterState state) {
            return const MapScreen();
          },
        ),
      ],
    ),
  ],
);

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.errorDetails});
  final String errorDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: Text(errorDetails.toString())),
      ),
    );
  }
}

get getContext => router.routerDelegate.navigatorKey.currentContext;
