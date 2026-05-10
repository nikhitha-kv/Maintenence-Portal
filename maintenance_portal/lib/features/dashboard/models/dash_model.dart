class DashModel {
  final int totalNotifications;
  final int totalWorkOrders;
  final int todayNotifications;
  final int todayWorkOrders;

  DashModel({
    required this.totalNotifications,
    required this.totalWorkOrders,
    required this.todayNotifications,
    required this.todayWorkOrders,
  });

  factory DashModel.fromJson(Map<String, dynamic> json) {
    // Assuming SAP response field names. Adjust if different.
    return DashModel(
      totalNotifications: int.tryParse(json['TotalNotif']?.toString() ?? '0') ?? 0,
      totalWorkOrders: int.tryParse(json['TotalWorkOrd']?.toString() ?? '0') ?? 0,
      todayNotifications: int.tryParse(json['TodayNotif']?.toString() ?? '0') ?? 0,
      todayWorkOrders: int.tryParse(json['TodayWorkOrd']?.toString() ?? '0') ?? 0,
    );
  }
}
