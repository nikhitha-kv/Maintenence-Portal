import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../models/notification_model.dart';
import '../models/notification_filter.dart';
import 'notification_controller.dart';
import 'notification_detail_screen.dart';
import '../../../shared/widgets/premium_search_bar.dart';
import '../../../shared/widgets/premium_filter_sheet.dart';

class NotificationListScreen extends ConsumerStatefulWidget {
  const NotificationListScreen({super.key});

  @override
  ConsumerState<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends ConsumerState<NotificationListScreen> {
  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final filteredNotifications = ref.watch(filteredNotificationsProvider);
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(notificationsProvider),
        child: CustomScrollView(
          slivers: [
          _buildSliverAppBar(context),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: notificationsAsync.when(
                data: (_) => _buildList(filteredNotifications, isDarkMode),
                loading: () => _buildSliverShimmer(),
                error: (err, _) => SliverFillRemaining(
                  child: Center(child: Text('Error: $err')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateNotificationSheet(BuildContext context) {
    final textController = TextEditingController();
    String selectedPriority = '3'; // Medium

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Notification',
                style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Report a new maintenance issue to the system',
                style: GoogleFonts.outfit(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'DESCRIPTION',
                  hintText: 'e.g. Pump leak in Sector B',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Text('PRIORITY', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _priorityChip('1', 'HIGH', AppColors.error, selectedPriority, (val) => setModalState(() => selectedPriority = val)),
                  const SizedBox(width: 8),
                  _priorityChip('3', 'MEDIUM', AppColors.warning, selectedPriority, (val) => setModalState(() => selectedPriority = val)),
                  const SizedBox(width: 8),
                  _priorityChip('5', 'LOW', AppColors.success, selectedPriority, (val) => setModalState(() => selectedPriority = val)),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    if (textController.text.isEmpty) return;
                    await ref.read(createNotificationProvider.notifier).createNotification(
                      textController.text,
                      selectedPriority,
                    );
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'SUBMIT NOTIFICATION',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priorityChip(String value, String label, Color color, String selected, Function(String) onSelect) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onSelect(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final filters = ref.watch(notificationFilterProvider);
          final notifier = ref.read(notificationFilterProvider.notifier);

          return PremiumFilterSheet(
            title: 'Filter Notifications',
            onReset: () => notifier.reset(),
            onApply: () => Navigator.pop(context),
            children: [
              FilterSection(
                title: 'Priority',
                child: Wrap(
                  spacing: 12,
                  children: [
                    PremiumFilterChip(
                      label: 'High',
                      isSelected: filters.priorities.contains('1'),
                      onTap: () {
                        final newPrio = List<String>.from(filters.priorities);
                        newPrio.contains('1') ? newPrio.remove('1') : newPrio.add('1');
                        notifier.setPriorities(newPrio);
                      },
                    ),
                    PremiumFilterChip(
                      label: 'Medium',
                      isSelected: filters.priorities.contains('3'),
                      onTap: () {
                        final newPrio = List<String>.from(filters.priorities);
                        newPrio.contains('3') ? newPrio.remove('3') : newPrio.add('3');
                        notifier.setPriorities(newPrio);
                      },
                    ),
                    PremiumFilterChip(
                      label: 'Low',
                      isSelected: filters.priorities.contains('5'),
                      onTap: () {
                        final newPrio = List<String>.from(filters.priorities);
                        newPrio.contains('5') ? newPrio.remove('5') : newPrio.add('5');
                        notifier.setPriorities(newPrio);
                      },
                    ),
                  ],
                ),
              ),
              FilterSection(
                title: 'Sort By',
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: SortOption.values.map((option) {
                    return PremiumFilterChip(
                      label: option.name.toUpperCase(),
                      isSelected: filters.sortBy == option,
                      onTap: () => notifier.setSortBy(option),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final filters = ref.watch(notificationFilterProvider);
    final hasActiveFilters = filters.priorities.isNotEmpty || filters.sortBy != SortOption.newest;

    final isDarkMode = ref.watch(themeProvider);
    return SliverAppBar(
      expandedHeight: 160,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 85),
        title: Text(
          'Notifications',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w800,
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 28,
          ),
        ),
        background: Stack(
          children: [
            Container(decoration: BoxDecoration(color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02))),
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: PremiumSearchBar(
            initialValue: ref.read(notificationSearchProvider),
            hintText: 'Search diagnostics...',
            onChanged: (val) => ref.read(notificationSearchProvider.notifier).state = val,
            onFilterTap: () => _showFilterSheet(context),
            hasActiveFilters: hasActiveFilters,
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<NotificationModel> notifications, bool isDarkMode) {
    if (notifications.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('No notifications found')),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = notifications[index];
          return _buildNotificationCard(context, item, isDarkMode);
        },
        childCount: notifications.length,
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationModel item, bool isDarkMode) {
    final bool isHighPriority = item.priority == '1' || item.priority.toLowerCase() == 'high';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationDetailScreen(notification: item),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDarkMode ? AppColors.primary.withOpacity(0.1) : const Color(0xFF2575FC).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#${item.qmnum}',
                        style: TextStyle(
                          color: isDarkMode ? AppColors.primary : const Color(0xFF2575FC),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    _buildPriorityBadge(item.priority, isHighPriority),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.qmtxt,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 14, color: isDarkMode ? Colors.white70 : Colors.black45),
                    const SizedBox(width: 4),
                    Text(
                      item.ernam,
                      style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white70 : Colors.black45),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.calendar_today_outlined, size: 14, color: isDarkMode ? Colors.white70 : Colors.black45),
                    const SizedBox(width: 4),
                    Text(
                      item.erdat,
                      style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white70 : Colors.black45),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String priority, bool isHigh) {
    final color = isHigh ? AppColors.error : AppColors.success;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            priority.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverShimmer() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 120,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        childCount: 5,
      ),
    );
  }
}
