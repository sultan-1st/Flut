import 'package:flutter/material.dart';
import 'package:login_signup/appAssets/assets.dart';
import 'package:login_signup/firebase_auth/auth.dart';
import 'package:login_signup/providers/add_favorite.dart';
import 'package:login_signup/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:login_signup/providers/profile_provider.dart';
import 'package:login_signup/screens/dashboard/profile_screen.dart';
import 'package:login_signup/screens/feedback_screen.dart'; // Import Feedback Screen
import 'package:login_signup/screens/maps/map_screen.dart'; // Import Map Screen

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
      profileProvider.fetchProfile();
      favoriteProvider.fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    const Color greenColor = Color.fromARGB(255, 56, 141, 35);
    const Color backgroundColor = Color.fromARGB(255, 255, 251, 251); // Light grey background color
    const Color logoutButtonColor = Color(0xFFD32F2F); // Subtle red color

    return Scaffold(
      backgroundColor: backgroundColor, // Set the background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: profileProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color.fromARGB(255, 59, 201, 24)),
                )
              : profileProvider.profile == null
                  ? const Center(child: Text("No profile data available"))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sidebar with Profile Header and Buttons
                        SizedBox(
                          width: 250, // Adjusted width for sidebar
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProfileHeader(profileProvider),
                              const SizedBox(height: 20),
                              // Dashboard Buttons
                              Expanded(child: _buildDashboardButtons(context, greenColor)),
                              const SizedBox(height: 20),
                              // Recent Activities
                              _buildRecentActivities(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Main Content (Map Screen)
                        Expanded(
                          flex: 4, // Increased flex for the map to take more space
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: const MapScreen(), // Embed the MapScreen
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  /// Builds the profile header with image, name, and greeting
  Widget _buildProfileHeader(ProfileProvider profileProvider) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: profileProvider.profile?.profileImage != null
              ? FileImage(profileProvider.profile!.profileImage!)
              : const AssetImage(Assets.avatar) as ImageProvider,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hey 👋',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              "${profileProvider.profile!.firstName} ${profileProvider.profile!.lastName}",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the list of dashboard action buttons
  Widget _buildDashboardButtons(BuildContext context, Color greenColor) {
    const Color backgroundColor = Color(0xFFF5F5F5); // Light grey background color
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDashboardButton(
          text: '  Manage my Profile',
          icon: Icons.person,
          backgroundColor: greenColor,
          textColor: Colors.white,
          onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()),
          ),
        ),
        const SizedBox(height: 10),
        _buildDashboardButton(
          text: '  History',
          icon: Icons.history,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => HistoryPage())),
        ),
        const SizedBox(height: 10),
        _buildDashboardButton(
          text: '  Favorite',
          icon: Icons.favorite,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => FavoritePage())),
        ),
        const SizedBox(height: 10),
        _buildDashboardButton(
          text: '  Balance',
          icon: Icons.account_balance_wallet,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => BalancePage())),
        ),
        const SizedBox(height: 10),
        _buildDashboardButton(
          text: '  Give Feedback',
          icon: Icons.feedback,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => FeedbackScreen())),
        ),
        const SizedBox(height: 10),
        _buildDashboardButton(
          text: '  Logout',
          icon: Icons.logout,
          backgroundColor: Color(0xFFD32F2F),
          textColor: Colors.white,
          onTap: () {
            Auth().signOut();
            router.go(Routes.onLoginRoute);
          },
        ),
      ],
    );
  }

  /// Custom reusable dashboard button with fixed width and icon
  Widget _buildDashboardButton({
    required String text,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 250, // Adjusted width to match recent activities
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(icon, color: textColor),
            ),
            Center(
              child: Text(
                text,
                style: TextStyle(color: textColor, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the recent activities section
  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: const Icon(Icons.directions_bus, color: Colors.grey),
          title: const Text('Trip to KAFD'),
          subtitle: const Text('30 minutes ago'),
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: const Icon(Icons.directions_bus, color: Colors.grey),
          title: const Text('Trip to Airport'),
          subtitle: const Text('1 hour ago'),
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

/// Screens for different sections

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          if (favoriteProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: favoriteProvider.favorites.length,
            itemBuilder: (context, index) {
              final fav = favoriteProvider.favorites[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  tileColor: Colors.white,
                  title: const Text("Station"),
                  subtitle: Text('${fav.lat}, ${fav.long}'),
                  trailing: GestureDetector(
                    onTap: () async => await favoriteProvider.removeFromFavorites(fav),
                    child: const Icon(Icons.cancel),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket History')),
      body: const Center(
        child: Text('History Not Found'),
      ),
    );
  }
}

class BalancePage extends StatelessWidget {
  const BalancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balance'),
      ),
      body: const ListTile(
        tileColor: Colors.white,
        title: Text('Balance:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Text('0.00 SAR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}