import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<UserModel> login(String empid, String password) async {
    final response = await _apiClient.get(AppEndpoints.login(empid, password));
    
    // SAP OData usually returns data in 'd' or 'd.results'
    final d = response.data['d'];
    if (d == null || d['results'] == null || (d['results'] as List).isEmpty) {
      return UserModel(
        empid: empid,
        message: 'Invalid Employee ID or Password',
        success: false,
      );
    }

    final data = d['results'][0];
    return UserModel.fromJson(data);
  }
}
