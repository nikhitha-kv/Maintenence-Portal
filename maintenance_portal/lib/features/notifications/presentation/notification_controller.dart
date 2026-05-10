import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../repository/notification_repository.dart';
import '../../auth/presentation/auth_controller.dart';

final notificationRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationRepository(apiClient);
});

final notificationsProvider = FutureProvider<List<NotificationModel>>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.getNotifications();
});

final notificationSearchProvider = StateProvider<String>((ref) => '');

final filteredNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notificationsAsync = ref.watch(notificationsProvider);
  final searchQuery = ref.watch(notificationSearchProvider).toLowerCase();

  return notificationsAsync.when(
    data: (notifications) {
      if (searchQuery.isEmpty) return notifications;
      return notifications.where((n) {
        return n.qmtxt.toLowerCase().contains(searchQuery) ||
               n.qmnum.toLowerCase().contains(searchQuery);
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
