import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:resto2/models/role_permission_model.dart';
import 'package:resto2/providers/auth_providers.dart';
import 'package:resto2/utils/constants.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).asData?.value;
    final authController = ref.read(authControllerProvider.notifier);

    if (currentUser == null) {
      return const Drawer(); // Return an empty drawer if user is not loaded
    }

    final bool canManageRestaurant =
        rolePermissions[currentUser.role]?.contains(
          Permission.manageRestaurantDetails,
        ) ??
        false;
    final bool canManageStaff =
        rolePermissions[currentUser.role]?.contains(Permission.manageStaff) ??
        false;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              currentUser.displayName ?? 'No Name',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(currentUser.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Text(
                currentUser.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(fontSize: 40.0),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              context.go(AppRoutes.home);
            },
          ),
          if (canManageRestaurant)
            ListTile(
              leading: const Icon(Icons.storefront_outlined),
              title: const Text('Manage Restaurant'),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.manageRestaurant);
              },
            ),
          if (canManageStaff)
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Manage Staff'),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.manageStaff);
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pop(context);
              authController.signOut();
            },
          ),
        ],
      ),
    );
  }
}
