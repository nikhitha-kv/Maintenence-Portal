import '../../notifications/models/notification_filter.dart';

class WorkOrderFilter {
  final List<String> orderTypes;
  final String? createdBy;
  final String? objectType;
  final SortOption sortBy;
  final DateTime? startDate;
  final DateTime? endDate;

  WorkOrderFilter({
    this.orderTypes = const [],
    this.createdBy,
    this.objectType,
    this.sortBy = SortOption.newest,
    this.startDate,
    this.endDate,
  });

  WorkOrderFilter copyWith({
    List<String>? orderTypes,
    String? createdBy,
    String? objectType,
    SortOption? sortBy,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return WorkOrderFilter(
      orderTypes: orderTypes ?? this.orderTypes,
      createdBy: createdBy ?? this.createdBy,
      objectType: objectType ?? this.objectType,
      sortBy: sortBy ?? this.sortBy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
