import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:resto2/controllers/staff_controller.dart';
import 'package:resto2/models/join_request_model.dart';
import 'package:resto2/models/staff_model.dart';
import 'package:resto2/services/staff_service.dart';
import 'auth_providers.dart';

// Provider for the new StaffService
final staffServiceProvider = Provider((ref) => StaffService());

final staffListStreamProvider = StreamProvider.autoDispose<List<Staff>>((ref) {
  final user = ref.watch(currentUserProvider).asData?.value;
  if (user?.restaurantId != null) {
    return ref.watch(staffServiceProvider).getStaffStream(user!.restaurantId!);
  }
  return Stream.value([]);
});

// Stream provider to get all pending join requests for the current restaurant
final joinRequestsStreamProvider =
    StreamProvider.autoDispose<List<JoinRequestModel>>((ref) {
      final user = ref.watch(currentUserProvider).asData?.value;

      if (user?.restaurantId != null) {
        return ref
            .watch(staffServiceProvider)
            .getPendingJoinRequests(user!.restaurantId!);
      }

      return Stream.value(<JoinRequestModel>[]);
    });

final staffControllerProvider = Provider.autoDispose<StaffController>((ref) {
  return StaffController(ref);
});
