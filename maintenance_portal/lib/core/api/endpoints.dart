class AppEndpoints {
  static const String baseUrl = 'https://AZKTLDS5CP.kcloud.com:44300/sap/opu/odata/SAP/ZMP_902095_ODATA_SRV';

  static String login(String empid, String passwd) => 
      '/LoginSet?\$filter=Empid%20eq%20\'$empid\'%20and%20Passwd%20eq%20\'$passwd\'';

  static const String dashboard = '/DashSet';
  static const String notifications = '/NotifSet';
  static const String workOrders = '/WorkOrdSet';
}
