import '../../../core/api/api_client.dart';
import '../../../core/api/endpoints.dart';
import '../models/work_order_model.dart';

class WorkOrderRepository {
  final ApiClient _apiClient;

  WorkOrderRepository(this._apiClient);

  Future<List<WorkOrderModel>> getWorkOrders() async {
    final response = await _apiClient.get(AppEndpoints.workOrders);
    final List results = response.data['d']['results'];
    return results.map((e) => WorkOrderModel.fromJson(e)).toList();
  }
}
