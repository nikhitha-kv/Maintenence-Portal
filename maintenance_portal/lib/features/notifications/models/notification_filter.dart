enum SortOption { newest, oldest, alphabetical, priority }

class NotificationFilter {
  final List<String> priorities;
  final String? notificationType;
  final String? createdBy;
  final SortOption sortBy;

  NotificationFilter({
    this.priorities = const [],
    this.notificationType,
    this.createdBy,
    this.sortBy = SortOption.newest,
  });

  NotificationFilter copyWith({
    List<String>? priorities,
    String? notificationType,
    String? createdBy,
    SortOption? sortBy,
  }) {
    return NotificationFilter(
      priorities: priorities ?? this.priorities,
      notificationType: notificationType ?? this.notificationType,
      createdBy: createdBy ?? this.createdBy,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}
