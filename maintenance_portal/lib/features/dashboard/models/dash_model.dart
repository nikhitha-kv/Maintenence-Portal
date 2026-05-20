class DashModel {
  final int totalNotifications;
  final int totalWorkOrders;
  final int todayNotifications;
  final int todayWorkOrders;
  final String oee;
  final String uptime;

  DashModel({
    required this.totalNotifications,
    required this.totalWorkOrders,
    required this.todayNotifications,
    required this.todayWorkOrders,
    this.oee = '94.2%',
    this.uptime = '99.8%',
  });

  factory DashModel.fromJson(Map<String, dynamic> json) {
    return DashModel(
      totalNotifications: int.tryParse(json['TotNotif']?.toString() ?? '0') ?? 0,
      totalWorkOrders: int.tryParse(json['TotWorkord']?.toString() ?? '0') ?? 0,
      todayNotifications: int.tryParse(json['TodNotif']?.toString() ?? '0') ?? 0,
      todayWorkOrders: int.tryParse(json['TodWorkord']?.toString() ?? '0') ?? 0,
      // Map these if they exist in the SAP response, otherwise default to demo values
      oee: json['Oee']?.toString() ?? '94.2%',
      uptime: json['Uptime']?.toString() ?? '99.8%',
    );
  }

  }

