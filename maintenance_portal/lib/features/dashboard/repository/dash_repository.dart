import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../models/dash_model.dart';

class DashRepository {
  final ApiClient _apiClient;

  DashRepository(this._apiClient);

  Future<DashModel> getDashboardData() async {
    final response = await _apiClient.get(AppEndpoints.dashboard);
    final data = response.data['d']['results'][0];
    return DashModel.fromJson(data);
  }
}
