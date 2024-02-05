// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isDrawerOpen = false;

  final List<Widget> _children = [
    const CourseRegistration(),
    const FeePayment(),
    const ELearning(),
    const ResultProcessing(),
    const HostelManagement()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onDrawerTapped() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  void _updateProfile() async {
    // Show a loading indicator while the profile is being updated
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Simulate an async operation to update the profile
    await Future.delayed(const Duration(seconds: 2));

    // Hide the loading indicator
    Navigator.of(context).pop();

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _logout() {
    // Show a confirmation dialog before logging out
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Perform logout logic here
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login');
                // Clear any stored user data
                // ...
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          if (_isDrawerOpen)
            Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      'User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.account_circle,
                      color: Colors.blue,
                    ),
                    title: const Text(
                      'Update Profile',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      // Handle update profile button press
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.blue,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      // Handle logout button press
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: _children[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.class_, color: Colors.white),
            label: 'Course Registration',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment, color: Colors.white),
            label: 'Fee Payment',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school, color: Colors.white),
            label: 'E-Learning',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment, color: Colors.white),
            label: 'Result Processing',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house, color: Colors.white),
            label: 'Hostel Managemnet',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'User',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.account_circle,
                color: Colors.blue,
              ),
              title: const Text(
                'Update Profile',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                _updateProfile(); // Handle update profile button press
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.blue,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () {
                _logout(); // Handle logout button press
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CourseRegistration extends StatelessWidget {
  const CourseRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Course Registration',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class FeePayment extends StatelessWidget {
  const FeePayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Fee Payment',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class ELearning extends StatelessWidget {
  const ELearning({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'E-Learning',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class ResultProcessing extends StatelessWidget {
  const ResultProcessing({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Result Processing',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class HostelManagement extends StatelessWidget {
  const HostelManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Hostel Management',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }
}