import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_signup/routes/routes.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({
    super.key,
    required this.widget,
    required this.state,
  });

  final Widget widget;
  final GoRouterState state;

  @override
  RootScreenState createState() => RootScreenState();
}

class RootScreenState extends State<RootScreen> {
  int selectedIndex = 0;

  void getCurrentIndex(state) {
    if (state.fullPath?.contains(Routes.onDashboard)) {
      selectedIndex = 0;
    } else if (state.fullPath?.contains(Routes.onTicketsScreen)) {
      selectedIndex = 1;
    } else if (state.fullPath?.contains(Routes.onPlanner)) {
      selectedIndex = 2; 
    } else if (state.fullPath?.contains(Routes.onFavoritesScreen)) {
      selectedIndex = 4;
    } else {
      selectedIndex = 0;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  void goOtherTab(int index) {
    selectedIndex = index;

    String location = index == 0
        ? Routes.onDashboard
        : index == 1
            ? Routes.onTicketsScreen
            : index == 2
                ? Routes.onPlanner
                : index == 2
                    ? Routes.onPlanner
                    : Routes.onFavoritesScreen;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      GoRouter.of(context).go(location);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getCurrentIndex(widget.state);
    return Scaffold(
      body: widget.widget,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color.fromARGB(255, 234, 245, 234), // Set the background color globally
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_activity_outlined),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Planner',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: const Color.fromARGB(255, 34, 167, 40),
          unselectedItemColor: const Color.fromARGB(255, 49, 49, 49),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 56, 141, 35),
          ),
          showUnselectedLabels: true,
          onTap: goOtherTab,
        ),
      ),
    );
  }
}
