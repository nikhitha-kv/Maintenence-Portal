import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/work_order_model.dart';
import '../repository/work_order_repository.dart';
import '../../auth/presentation/auth_controller.dart';

final workOrderRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WorkOrderRepository(apiClient);
});

final workOrdersProvider = FutureProvider<List<WorkOrderModel>>((ref) async {
  final repository = ref.watch(workOrderRepositoryProvider);
  return repository.getWorkOrders();
});

final workOrderSearchProvider = StateProvider<String>((ref) => '');

final filteredWorkOrdersProvider = Provider<List<WorkOrderModel>>((ref) {
  final workOrdersAsync = ref.watch(workOrdersProvider);
  final searchQuery = ref.watch(workOrderSearchProvider).toLowerCase();

  return workOrdersAsync.when(
    data: (orders) {
      if (searchQuery.isEmpty) return orders;
      return orders.where((o) {
        return o.ktext.toLowerCase().contains(searchQuery) ||
               o.aufnr.toLowerCase().contains(searchQuery);
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
