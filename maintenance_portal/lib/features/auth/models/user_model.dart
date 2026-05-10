class UserModel {
  final String empid;
  final String message;
  final bool success;

  UserModel({
    required this.empid,
    required this.message,
    required this.success,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final message = json['Message'] ?? '';
    return UserModel(
      empid: json['Empid'] ?? '',
      message: message,
      success: json['Success'] == 'X' || 
               json['Success'] == 'S' || 
               json['Success'] == true || 
               message.toString().toLowerCase().contains('success'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Empid': empid,
      'Message': message,
      'Success': success ? 'X' : '',
    };
  }
}
