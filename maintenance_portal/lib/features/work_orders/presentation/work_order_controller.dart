import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/work_order_model.dart';
import '../repository/work_order_repository.dart';
import '../models/work_order_filter.dart';
import '../../notifications/models/notification_filter.dart'; // for SortOption
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

final workOrderFilterProvider = StateNotifierProvider<WorkOrderFilterNotifier, WorkOrderFilter>((ref) {
  return WorkOrderFilterNotifier();
});

class WorkOrderFilterNotifier extends StateNotifier<WorkOrderFilter> {
  WorkOrderFilterNotifier() : super(WorkOrderFilter());

  void setOrderTypes(List<String> types) => state = state.copyWith(orderTypes: types);
  void setSortBy(SortOption sortBy) => state = state.copyWith(sortBy: sortBy);
  void setObjectType(String? type) => state = state.copyWith(objectType: type);
  void setCreatedBy(String? user) => state = state.copyWith(createdBy: user);
  void reset() => state = WorkOrderFilter();
}

final filteredWorkOrdersProvider = Provider<List<WorkOrderModel>>((ref) {
  final workOrdersAsync = ref.watch(workOrdersProvider);
  final searchQuery = ref.watch(workOrderSearchProvider).toLowerCase();
  final filters = ref.watch(workOrderFilterProvider);

  return workOrdersAsync.when(
    data: (orders) {
      List<WorkOrderModel> filtered = orders;

      // Search filtering
      if (searchQuery.isNotEmpty) {
        filtered = filtered.where((o) {
          return o.ktext.toLowerCase().contains(searchQuery) ||
                 o.aufnr.toLowerCase().contains(searchQuery);
        }).toList();
      }

      // Order Type filtering
      if (filters.orderTypes.isNotEmpty) {
        filtered = filtered.where((o) => filters.orderTypes.contains(o.auart)).toList();
      }

      // Object Type filtering
      if (filters.objectType != null) {
        filtered = filtered.where((o) => o.aufnr.startsWith(filters.objectType!)).toList(); // Example logic
      }

      // Created By filtering
      if (filters.createdBy != null) {
        filtered = filtered.where((o) => o.ernam == filters.createdBy).toList();
      }

      // Sorting
      switch (filters.sortBy) {
        case SortOption.newest:
          filtered.sort((a, b) => b.erdat.compareTo(a.erdat));
          break;
        case SortOption.oldest:
          filtered.sort((a, b) => a.erdat.compareTo(b.erdat));
          break;
        case SortOption.alphabetical:
          filtered.sort((a, b) => a.ktext.compareTo(b.ktext));
          break;
        case SortOption.priority:
          // If work order has priority field, use it. For now, alphabetical as placeholder or by ID
          filtered.sort((a, b) => a.aufnr.compareTo(b.aufnr));
          break;
      }

      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
