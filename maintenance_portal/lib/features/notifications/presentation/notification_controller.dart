import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../repository/notification_repository.dart';
import '../models/notification_filter.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../../core/utils/date_formatter.dart';

final notificationRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationRepository(apiClient);
});

final notificationsProvider = FutureProvider<List<NotificationModel>>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.getNotifications();
});

final notificationSearchProvider = StateProvider<String>((ref) => '');

final notificationFilterProvider = StateNotifierProvider<NotificationFilterNotifier, NotificationFilter>((ref) {
  return NotificationFilterNotifier();
});

class NotificationFilterNotifier extends StateNotifier<NotificationFilter> {
  NotificationFilterNotifier() : super(NotificationFilter());

  void setPriorities(List<String> priorities) => state = state.copyWith(priorities: priorities);
  void setSortBy(SortOption sortBy) => state = state.copyWith(sortBy: sortBy);
  void setType(String? type) => state = state.copyWith(notificationType: type);
  void setCreatedBy(String? user) => state = state.copyWith(createdBy: user);
  void setDateRange(DateTime? start, DateTime? end) => state = state.copyWith(startDate: start, endDate: end);
  void reset() => state = NotificationFilter();
}

final createNotificationProvider = StateNotifierProvider<CreateNotificationNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return CreateNotificationNotifier(repository, ref);
});

class CreateNotificationNotifier extends StateNotifier<AsyncValue<void>> {
  final NotificationRepository _repository;
  final Ref _ref;

  CreateNotificationNotifier(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> createNotification(String text, String priority) async {
    state = const AsyncValue.loading();
    try {
      final data = {
        "Qmtxt": text,
        "Priority": priority,
        "Qmart": "M1", // Standard maintenance notification
        "Ernam": "K902095", // Hardcoded for now as per api_client
      };
      await _repository.createNotification(data);
      state = const AsyncValue.data(null);
      _ref.invalidate(notificationsProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final filteredNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notificationsAsync = ref.watch(notificationsProvider);
  final searchQuery = ref.watch(notificationSearchProvider).toLowerCase();
  final filters = ref.watch(notificationFilterProvider);

  return notificationsAsync.when(
    data: (notifications) {
      List<NotificationModel> filtered = notifications;

      // Search filtering
      if (searchQuery.isNotEmpty) {
        filtered = filtered.where((n) {
          return n.qmtxt.toLowerCase().contains(searchQuery) ||
                 n.qmnum.toLowerCase().contains(searchQuery);
        }).toList();
      }

      // Priority filtering
      if (filters.priorities.isNotEmpty) {
        filtered = filtered.where((n) => filters.priorities.contains(n.priority)).toList();
      }

      // Notification Type filtering
      if (filters.notificationType != null) {
        filtered = filtered.where((n) => n.qmart == filters.notificationType).toList();
      }

      // Created By filtering
      if (filters.createdBy != null) {
        filtered = filtered.where((n) => n.ernam == filters.createdBy).toList();
      }
      
      // Date Range filtering
      if (filters.startDate != null && filters.endDate != null) {
        final start = DateTime(filters.startDate!.year, filters.startDate!.month, filters.startDate!.day);
        final end = DateTime(filters.endDate!.year, filters.endDate!.month, filters.endDate!.day, 23, 59, 59);
        
        filtered = filtered.where((n) {
          final nDate = DateFormatter.toDateTime(n.erdat);
          if (nDate == null) return false;
          return (nDate.isAfter(start) || nDate.isAtSameMomentAs(start)) &&
                 (nDate.isBefore(end) || nDate.isAtSameMomentAs(end));
        }).toList();
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
          filtered.sort((a, b) => a.qmtxt.compareTo(b.qmtxt));
          break;
        case SortOption.priority:
          filtered.sort((a, b) => a.priority.compareTo(b.priority));
          break;
      }

      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
