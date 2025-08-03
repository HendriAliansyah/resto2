import 'package:resto2/models/role_permission_model.dart';

class Staff {
  final String uid;
  final String displayName;
  final String email;
  final UserRole role;
  final bool isDisabled;

  Staff({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.role,
    required this.isDisabled,
  });
}
