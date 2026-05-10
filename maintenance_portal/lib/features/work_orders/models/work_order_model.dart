class WorkOrderModel {
  final String aufnr;
  final String auart;
  final String ktext;
  final String erdat;
  final String aedat;
  final String ernam;
  final String objnr;
  final String autyp;

  WorkOrderModel({
    required this.aufnr,
    required this.auart,
    required this.ktext,
    required this.erdat,
    required this.aedat,
    required this.ernam,
    required this.objnr,
    required this.autyp,
  });

  factory WorkOrderModel.fromJson(Map<String, dynamic> json) {
    return WorkOrderModel(
      aufnr: json['Aufnr'] ?? '',
      auart: json['Auart'] ?? '',
      ktext: json['Ktext'] ?? '',
      erdat: json['Erdat'] ?? '',
      aedat: json['Aedat'] ?? '',
      ernam: json['Ernam'] ?? '',
      objnr: json['Objnr'] ?? '',
      autyp: json['Autyp'] ?? '',
    );
  }
}
