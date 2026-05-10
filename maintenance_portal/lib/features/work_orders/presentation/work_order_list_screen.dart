import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../models/work_order_model.dart';
import '../../notifications/models/notification_filter.dart'; // for SortOption
import '../../../core/theme/theme_provider.dart';
import 'work_order_controller.dart';
import 'work_order_detail_screen.dart';
import '../../../shared/widgets/premium_search_bar.dart';
import '../../../shared/widgets/premium_filter_sheet.dart';

class WorkOrderListScreen extends ConsumerStatefulWidget {
  const WorkOrderListScreen({super.key});

  @override
  ConsumerState<WorkOrderListScreen> createState() => _WorkOrderListScreenState();
}

class _WorkOrderListScreenState extends ConsumerState<WorkOrderListScreen> {
  @override
  Widget build(BuildContext context) {
    final workOrdersAsync = ref.watch(workOrdersProvider);
    final filteredOrders = ref.watch(filteredWorkOrdersProvider);
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: workOrdersAsync.when(
              data: (_) => _buildList(filteredOrders, isDarkMode),
              loading: () => _buildSliverShimmer(),
              error: (err, _) => SliverFillRemaining(
                child: Center(child: Text('Error: $err')),
              ),
            ),
          ),
        ],
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
          final filters = ref.watch(workOrderFilterProvider);
          final notifier = ref.read(workOrderFilterProvider.notifier);

          return PremiumFilterSheet(
            title: 'Filter Work Orders',
            onReset: () => notifier.reset(),
            onApply: () => Navigator.pop(context),
            children: [
              FilterSection(
                title: 'Order Type',
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: ['PM01', 'PM02', 'PM03'].map((type) {
                    return PremiumFilterChip(
                      label: type,
                      isSelected: filters.orderTypes.contains(type),
                      onTap: () {
                        final newTypes = List<String>.from(filters.orderTypes);
                        newTypes.contains(type) ? newTypes.remove(type) : newTypes.add(type);
                        notifier.setOrderTypes(newTypes);
                      },
                    );
                  }).toList(),
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
    final filters = ref.watch(workOrderFilterProvider);
    final hasActiveFilters = filters.orderTypes.isNotEmpty || filters.sortBy != SortOption.newest;

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
          'Work Orders',
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
              left: -50,
              bottom: -50,
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
            initialValue: ref.read(workOrderSearchProvider),
            hintText: 'Search operations...',
            onChanged: (val) => ref.read(workOrderSearchProvider.notifier).state = val,
            onFilterTap: () => _showFilterSheet(context),
            hasActiveFilters: hasActiveFilters,
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<WorkOrderModel> orders, bool isDarkMode) {
    if (orders.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('No work orders found')),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = orders[index];
          return _buildWorkOrderCard(context, item, isDarkMode);
        },
        childCount: orders.length,
      ),
    );
  }

  Widget _buildWorkOrderCard(BuildContext context, WorkOrderModel item, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? AppColors.secondary.withOpacity(0.05) : Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkOrderDetailScreen(workOrder: item),
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
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'WO #${item.aufnr}',
                        style: const TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      item.auart,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black45,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.ktext,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconInfo(context, Icons.person_outline, item.ernam, isDarkMode),
                    _buildIconInfo(context, Icons.calendar_today_outlined, item.erdat, isDarkMode),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconInfo(BuildContext context, IconData icon, String text, bool isDarkMode) {
    return Row(
      children: [
        Icon(icon, size: 14, color: isDarkMode ? Colors.white70 : Colors.black45),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white70 : Colors.black54),
        ),
      ],
    );
  }

  Widget _buildSliverShimmer() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 140,
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
