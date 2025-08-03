import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:resto2/models/join_request_model.dart';
import 'package:resto2/models/role_permission_model.dart';
import 'package:resto2/providers/auth_providers.dart';
import 'package:resto2/providers/staff_provider.dart';
import 'package:resto2/utils/constants.dart';
import 'package:resto2/utils/snackbar.dart';
import 'package:resto2/views/widgets/app_drawer.dart';
import 'package:resto2/views/widgets/loading_indicator.dart';

class StaffManagementPage extends HookConsumerWidget {
  const StaffManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Staff Management'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people_outline), text: 'Current Staff'),
              Tab(
                icon: Icon(Icons.person_add_alt_1_outlined),
                text: 'Join Requests',
              ),
            ],
          ),
        ),
        drawer: const AppDrawer(),
        body: const TabBarView(
          children: [CurrentStaffView(), JoinRequestsView()],
        ),
      ),
    );
  }
}

// Widget for the "Current Staff" tab
class CurrentStaffView extends ConsumerWidget {
  const CurrentStaffView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffListAsync = ref.watch(staffListStreamProvider);

    return staffListAsync.when(
      data: (staffList) {
        if (staffList.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.no_accounts, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No Staff Found',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'When users join your restaurant, they will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: staffList.length,
          itemBuilder: (context, index) {
            final staff = staffList[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(staff.displayName),
                subtitle: Text('${staff.role.name} - ${staff.email}'),
                trailing: Icon(
                  staff.isDisabled
                      ? Icons.lock_person_outlined
                      : Icons.chevron_right,
                  color: staff.isDisabled ? Colors.redAccent : null,
                ),
                onTap: () {
                  context.push(AppRoutes.editStaff, extra: staff);
                },
              ),
            );
          },
        );
      },
      loading: () => const LoadingIndicator(),
      error: (e, st) => Center(child: Text('Error: ${e.toString()}')),
    );
  }
}

// Widget for the "Join Requests" tab
class JoinRequestsView extends HookConsumerWidget {
  const JoinRequestsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ... (This widget's code remains the same)
    final joinRequestsAsync = ref.watch(joinRequestsStreamProvider);
    final staffController = ref.read(staffControllerProvider);
    final restaurantId =
        ref.watch(currentUserProvider).asData?.value?.restaurantId;
    final processingRequestId = useState<String?>(null);

    void onAccept(JoinRequestModel request) async {
      if (restaurantId == null) return;
      processingRequestId.value = request.userId;

      final selectedRole = await showDialog<UserRole>(
        context: context,
        builder: (context) {
          UserRole role = UserRole.cashier; // Default role
          return AlertDialog(
            title: const Text('Assign a Role'),
            content: DropdownButtonFormField<UserRole>(
              value: role,
              items:
                  UserRole.values
                      .map(
                        (r) => DropdownMenuItem(value: r, child: Text(r.name)),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) role = value;
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(role),
                child: const Text('Assign'),
              ),
            ],
          );
        },
      );

      if (selectedRole != null) {
        try {
          await staffController.approveJoinRequest(
            restaurantId: restaurantId,
            userId: request.userId,
            role: selectedRole,
          );
          if (context.mounted)
            showSnackBar(
              context,
              '${request.userDisplayName} has been added to your staff.',
            );
        } catch (e) {
          if (context.mounted)
            showSnackBar(context, 'Error: ${e.toString()}', isError: true);
        } finally {
          if (context.mounted) processingRequestId.value = null;
        }
      } else {
        if (context.mounted) processingRequestId.value = null;
      }
    }

    void onReject(JoinRequestModel request) async {
      if (restaurantId == null) return;
      processingRequestId.value = request.userId;
      try {
        await staffController.rejectJoinRequest(
          restaurantId: restaurantId,
          userId: request.userId,
        );
        if (context.mounted)
          showSnackBar(
            context,
            'Request from ${request.userDisplayName} has been rejected.',
          );
      } catch (e) {
        if (context.mounted)
          showSnackBar(context, 'Error: ${e.toString()}', isError: true);
      } finally {
        if (context.mounted) processingRequestId.value = null;
      }
    }

    return joinRequestsAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.group_add_outlined, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No Pending Requests',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'When a new user requests to join your restaurant, you will see their request here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            final isProcessing = processingRequestId.value == request.userId;

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(request.userDisplayName),
                subtitle: Text(request.userEmail),
                trailing:
                    isProcessing
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        )
                        : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              tooltip: 'Reject',
                              onPressed: () => onReject(request),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              tooltip: 'Accept',
                              onPressed: () => onAccept(request),
                            ),
                          ],
                        ),
              ),
            );
          },
        );
      },
      loading: () => const LoadingIndicator(),
      error:
          (e, st) =>
              Center(child: Text('Error loading requests: ${e.toString()}')),
    );
  }
}
