import '../../notifications/models/notification_filter.dart';

class WorkOrderFilter {
  final List<String> orderTypes;
  final String? createdBy;
  final String? objectType;
  final SortOption sortBy;

  WorkOrderFilter({
    this.orderTypes = const [],
    this.createdBy,
    this.objectType,
    this.sortBy = SortOption.newest,
  });

  WorkOrderFilter copyWith({
    List<String>? orderTypes,
    String? createdBy,
    String? objectType,
    SortOption? sortBy,
  }) {
    return WorkOrderFilter(
      orderTypes: orderTypes ?? this.orderTypes,
      createdBy: createdBy ?? this.createdBy,
      objectType: objectType ?? this.objectType,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}
