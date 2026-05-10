class NotificationModel {
  final String qmnum;
  final String qmart;
  final String qmtxt;
  final String priority;
  final String erdat;
  final String ernam;
  final String aedat;
  final String aenam;
  final String qmdat;
  final String mzeit;
  final String qmnam;
  final String strmn;

  NotificationModel({
    required this.qmnum,
    required this.qmart,
    required this.qmtxt,
    required this.priority,
    required this.erdat,
    required this.ernam,
    required this.aedat,
    required this.aenam,
    required this.qmdat,
    required this.mzeit,
    required this.qmnam,
    required this.strmn,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      qmnum: json['Qmnum'] ?? '',
      qmart: json['Qmart'] ?? '',
      qmtxt: json['Qmtxt'] ?? '',
      priority: json['Priority'] ?? '',
      erdat: json['Erdat'] ?? '',
      ernam: json['Ernam'] ?? '',
      aedat: json['Aedat'] ?? '',
      aenam: json['Aenam'] ?? '',
      qmdat: json['Qmdat'] ?? '',
      mzeit: json['Mzeit'] ?? '',
      qmnam: json['Qmnam'] ?? '',
      strmn: json['Strmn'] ?? '',
    );
  }
}
