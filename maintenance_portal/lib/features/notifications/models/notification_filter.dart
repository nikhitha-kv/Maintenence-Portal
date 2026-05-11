enum SortOption { newest, oldest, alphabetical, priority }

class NotificationFilter {
  final List<String> priorities;
  final String? notificationType;
  final String? createdBy;
  final SortOption sortBy;
  final DateTime? startDate;
  final DateTime? endDate;

  NotificationFilter({
    this.priorities = const [],
    this.notificationType,
    this.createdBy,
    this.sortBy = SortOption.newest,
    this.startDate,
    this.endDate,
  });

  NotificationFilter copyWith({
    List<String>? priorities,
    String? notificationType,
    String? createdBy,
    SortOption? sortBy,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return NotificationFilter(
      priorities: priorities ?? this.priorities,
      notificationType: notificationType ?? this.notificationType,
      createdBy: createdBy ?? this.createdBy,
      sortBy: sortBy ?? this.sortBy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
