import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepository(this._apiClient);

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiClient.get(AppEndpoints.notifications);
    final List results = response.data['d']['results'];
    return results.map((e) => NotificationModel.fromJson(e)).toList();
  }

  Future<void> createNotification(Map<String, dynamic> data) async {
    await _apiClient.post(AppEndpoints.notifications, data: data);
  }
}
