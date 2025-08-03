enum UserRole {
  /// Has full control over the restaurant, staff, and finances.
  owner,

  /// Has the same full control permissions as an owner.
  admin,

  /// Can handle daily operations, manage staff, and menus.
  manager,

  /// Can only take orders and process payments.
  cashier,
}

enum Permission {
  manageRestaurantDetails,
  manageStaff,
  viewReports,
  manageMenu,
  takeOrders,
  processPayments,
}

/// Defines the permissions granted to each user role.
const Map<UserRole, Set<Permission>> rolePermissions = {
  UserRole.owner: {
    Permission.manageRestaurantDetails,
    Permission.manageStaff,
    Permission.viewReports,
    Permission.manageMenu,
    Permission.takeOrders,
    Permission.processPayments,
  },
  // THE NEW ROLE: 'admin' has the same permissions as 'owner'.
  UserRole.admin: {
    Permission.manageRestaurantDetails,
    Permission.manageStaff,
    Permission.viewReports,
    Permission.manageMenu,
    Permission.takeOrders,
    Permission.processPayments,
  },
  UserRole.manager: {
    Permission.manageStaff,
    Permission.manageMenu,
    Permission.takeOrders,
    Permission.processPayments,
  },
  UserRole.cashier: {Permission.takeOrders, Permission.processPayments},
};
