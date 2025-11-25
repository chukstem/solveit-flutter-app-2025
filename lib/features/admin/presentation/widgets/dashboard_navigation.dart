import 'package:flutter/material.dart';

class DashboardNavigationRail extends StatelessWidget {
  final String selectedSection;
  final Function(String) onSectionSelected;
  final ColorScheme colorScheme;

  const DashboardNavigationRail({
    super.key,
    required this.selectedSection,
    required this.onSectionSelected,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: _getSelectedIndex(selectedSection),
      onDestinationSelected: (index) => onSectionSelected(_getSectionName(index)),
      extended: true,
      backgroundColor: colorScheme.surface,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: Text('School Management'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.post_add_outlined),
          selectedIcon: Icon(Icons.post_add),
          label: Text('Posts Management'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.admin_panel_settings_outlined),
          selectedIcon: Icon(Icons.admin_panel_settings),
          label: Text('Roles & Permissions'),
        ),
      ],
    );
  }

  int _getSelectedIndex(String section) {
    switch (section) {
      case 'dashboard':
        return 0;
      case 'school':
        return 1;
      case 'posts':
        return 2;
      case 'roles':
        return 3;
      default:
        return 0;
    }
  }

  String _getSectionName(int index) {
    switch (index) {
      case 0:
        return 'dashboard';
      case 1:
        return 'school';
      case 2:
        return 'posts';
      case 3:
        return 'roles';
      default:
        return 'dashboard';
    }
  }
}

class DashboardBottomNavigation extends StatelessWidget {
  final String selectedSection;
  final Function(String) onSectionSelected;

  const DashboardBottomNavigation({
    super.key,
    required this.selectedSection,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _getSelectedIndex(selectedSection),
      onTap: (index) => onSectionSelected(_getSectionName(index)),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          activeIcon: Icon(Icons.school),
          label: 'Schools',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.post_add_outlined),
          activeIcon: Icon(Icons.post_add),
          label: 'Posts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings_outlined),
          activeIcon: Icon(Icons.admin_panel_settings),
          label: 'Roles',
        ),
      ],
    );
  }

  int _getSelectedIndex(String section) {
    switch (section) {
      case 'dashboard':
        return 0;
      case 'school':
        return 1;
      case 'posts':
        return 2;
      case 'roles':
        return 3;
      default:
        return 0;
    }
  }

  String _getSectionName(int index) {
    switch (index) {
      case 0:
        return 'dashboard';
      case 1:
        return 'school';
      case 2:
        return 'posts';
      case 3:
        return 'roles';
      default:
        return 'dashboard';
    }
  }
}
