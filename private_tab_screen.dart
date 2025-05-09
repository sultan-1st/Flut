import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:login_signup/firebase_auth/auth.dart';
import 'package:login_signup/routes/routes.dart';

class PrivateTabScreen extends StatelessWidget {
  const PrivateTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(color: Colors.white), // Change the color of the title
        ),
        backgroundColor: Color.fromARGB(255, 40, 133, 17),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white), // Change the color of the icon
            onPressed: () {
              // Handle logout
              // Navigate to the login screen using GoRouter
              Auth().signOut();
              router.go(Routes.onLoginRoute);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Here is your dashboard overview:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildDashboardCard(
                    context,
                    title: 'Total Users',
                    content: '1000',
                    icon: Icons.people,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDashboardCard(
                    context,
                    title: 'Active Users',
                    content: '150',
                    icon: Icons.person,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildDashboardCard(
                    context,
                    title: 'Ticket Sales',
                    content: 'Tickets Sold: 250',
                    icon: Icons.confirmation_number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDashboardCard(
                    context,
                    title: 'Total Revenue',
                    content: 'Total Revenue: \$5,000',
                    icon: Icons.attach_money,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildDashboardCard(
                    context,
                    title: 'Total Trains Running',
                    content: 'Active Trains: 10',
                    icon: Icons.train,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDashboardCard(
                    context,
                    title: 'Delay Status',
                    content: 'Train 123: Delayed',
                    icon: Icons.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildUserList(),
            const SizedBox(height: 20),
            _buildChart(),
            const SizedBox(height: 20),
            _buildUpcomingDepartures(),
            const SizedBox(height: 20),
            _buildRecentLogins(),
            const SizedBox(height: 20),
            _buildRecentActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, {required String title, required String content, required IconData icon}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Color.fromARGB(255, 40, 133, 17)), // Reduced icon size
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Reduced font size
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              content,
              style: const TextStyle(fontSize: 14), // Reduced font size
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.list, size: 36, color: Color.fromARGB(255, 40, 133, 17)), // Reduced icon size
            title: Text('User List', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Reduced font size
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('User ${index + 1}'),
                subtitle: Text('user${index + 1}@example.com'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.bar_chart, size: 36, color: Color.fromARGB(255, 40, 133, 17)), // Reduced icon size
            title: Text('Ticket Sales Chart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Reduced font size
          ),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(y: 5, colors: [Color.fromARGB(255, 40, 133, 17)])]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(y: 6, colors: [Color.fromARGB(255, 40, 133, 17)])]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(y: 8, colors: [Color.fromARGB(255, 40, 133, 17)])]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(y: 7, colors: [Color.fromARGB(255, 40, 133, 17)])]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(y: 5, colors: [Color.fromARGB(255, 40, 133, 17)])]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(y: 6, colors: [Color.fromARGB(255, 40, 133, 17)])]),
                  BarChartGroupData(x: 6, barRods: [BarChartRodData(y: 7, colors: [Color.fromARGB(255, 40, 133, 17)])]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingDepartures() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.schedule, size: 36, color: Color.fromARGB(255, 40, 133, 17)), // Reduced icon size
            title: Text('Upcoming Departures', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Reduced font size
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('Train')),
              DataColumn(label: Text('Time')),
              DataColumn(label: Text('Destination')),
            ],
            rows: List<DataRow>.generate(
              5,
              (index) => DataRow(
                cells: [
                  DataCell(Text('Train ${index + 1}')),
                  DataCell(Text('10:${index}0 AM')),
                  DataCell(Text('Destination ${index + 1}')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentLogins() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.login, size: 36, color: Color.fromARGB(255, 40, 133, 17)), // Reduced icon size
            title: Text('Recent Logins', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Reduced font size
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('User${index + 1} logged in at 10:${index}0 AM'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActions() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.history, size: 36, color: Color.fromARGB(255, 40, 133, 17)), // Reduced icon size
            title: Text('Recent Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // Reduced font size
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Admin updated user roles'),
              );
            },
          ),
        ],
      ),
    );
  }
}