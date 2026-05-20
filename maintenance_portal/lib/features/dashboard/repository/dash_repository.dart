import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../models/dash_model.dart';

class DashRepository {
  final ApiClient _apiClient;

  DashRepository(this._apiClient);

Future<DashModel> getDashboardData() async {
    // Parallel fetch of dashboard, notifications, and work orders
    final dashFuture = _apiClient.get(AppEndpoints.dashboard);
    final notifFuture = _apiClient.get(AppEndpoints.notifications);
    final workOrdFuture = _apiClient.get(AppEndpoints.workOrders);

    // Await all responses
    final responses = await Future.wait([dashFuture, notifFuture, workOrdFuture]);
    final dashResponse = responses[0];
    final notifResponse = responses[1];
    final workOrdResponse = responses[2];

    // Debug logging of raw responses
    print('--- Dashboard OData raw ---');
    print(dashResponse.data);
    print('--- Notifications OData raw (first 5) ---');
    print((notifResponse.data['d']['results'] as List).take(5).toList());
    print('--- WorkOrders OData raw (first 5) ---');
    print((workOrdResponse.data['d']['results'] as List).take(5).toList());

    // Parse the dashboard summary (first result)
    final dashData = dashResponse.data['d']['results'][0];
    // Build the model using the updated keys
    return DashModel.fromJson(dashData);
  }

}
