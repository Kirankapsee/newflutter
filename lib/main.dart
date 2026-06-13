import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class NavItem {
  const NavItem({
    required this.label,
    required this.icon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final String path;
}

const List<NavItem> kNavItems = [
  NavItem(label: 'Dashboard', icon: Icons.dashboard_outlined, path: '/'),
  NavItem(label: 'Projects', icon: Icons.folder_open_outlined, path: '/projects'),
  NavItem(label: 'Settings', icon: Icons.settings_outlined, path: '/settings'),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GoRouter _router = GoRouter(
    routes: [
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return AppShell(state: state, child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) {
              return const _SectionPage(
                title: 'Dashboard',
                subtitle: 'Overview of your web app state.',
                color: Color(0xFFE3F2FD),
              );
            },
          ),
          GoRoute(
            path: '/projects',
            builder: (BuildContext context, GoRouterState state) {
              return const _SectionPage(
                title: 'Projects',
                subtitle: 'Manage active projects and recent updates.',
                color: Color(0xFFE8F5E9),
              );
            },
          ),
          GoRoute(
            path: '/settings',
            builder: (BuildContext context, GoRouterState state) {
              return const _SectionPage(
                title: 'Settings',
                subtitle: 'Configure app preferences for web.',
                color: Color(0xFFFFF8E1),
              );
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Web Drawer',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF005F73)),
        useMaterial3: true,
      ),
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.state,
    required this.child,
  });

  final GoRouterState state;
  final Widget child;

  int _selectedIndex(String location) {
    final String matched = location == '/' ? '/' : location;
    final int index = kNavItems.indexWhere((NavItem item) {
      if (item.path == '/') {
        return matched == '/';
      }
      return matched.startsWith(item.path);
    });
    return index == -1 ? 0 : index;
  }

  Widget _buildNavDrawer(BuildContext context, int selectedIndex) {
    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) {
        context.go(kNavItems[index].path);
      },
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 16, 12),
          child: Text(
            'Navigation',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        ...kNavItems.map(
          (NavItem item) => NavigationDrawerDestination(
            icon: Icon(item.icon),
            label: Text(item.label),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _selectedIndex(state.uri.path);
    final bool isWideLayout = MediaQuery.of(context).size.width >= 900;

    if (isWideLayout) {
      return Scaffold(
        appBar: AppBar(title: const Text('Flutter Web App')),
        body: Row(
          children: <Widget>[
            SizedBox(
              width: 280,
              child: _buildNavDrawer(context, selectedIndex),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Web App')),
      drawer: Drawer(child: _buildNavDrawer(context, selectedIndex)),
      body: child,
    );
  }
}

class _SectionPage extends StatelessWidget {
  const _SectionPage({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 720),
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
