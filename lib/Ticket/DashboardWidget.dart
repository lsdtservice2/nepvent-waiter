import 'package:flutter/material.dart';
import 'package:nepvent_waiter/Ticket/TicketGenerateWidget.dart';
import 'package:nepvent_waiter/Ticket/TicketHistoryWidget.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // socketService.couponListenSockets();
  }

  // List of pages to display for each tab
  final List<Widget> _pages = [
    const TicketGenerateWidget(),
    const TicketHistoryWidget(),
    // ProfileWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Change the selected index
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), label: 'History'),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Profile',
          // ),
        ],
      ),
    );
  }
}
