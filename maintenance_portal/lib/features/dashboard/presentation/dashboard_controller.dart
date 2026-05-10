import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dash_model.dart';
import '../repository/dash_repository.dart';
import '../../auth/presentation/auth_controller.dart';

final dashRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DashRepository(apiClient);
});

final dashboardDataProvider = FutureProvider<DashModel>((ref) async {
  final repository = ref.watch(dashRepositoryProvider);
  return repository.getDashboardData();
});
