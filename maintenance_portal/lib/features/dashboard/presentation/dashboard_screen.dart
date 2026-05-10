import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../models/dash_model.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashData = ref.watch(dashboardDataProvider);
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, ref),
          SliverToBoxAdapter(
            child: RefreshIndicator(
              onRefresh: () => ref.refresh(dashboardDataProvider.future),
              child: dashData.when(
                data: (data) => _buildDashboardContent(context, data, isDarkMode),
                loading: () => _buildShimmer(context),
                error: (err, stack) => _buildErrorState(err),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Text(
          'Industrial Hub',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: 24,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.help_outline_rounded, color: isDarkMode ? Colors.white : Colors.black54),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashModel data, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(context, isDarkMode),
          const SizedBox(height: 24),
          _buildKPIGrid(context, data, isDarkMode),
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'Live Activity Feed', Icons.rss_feed_rounded, isDarkMode),
          const SizedBox(height: 16),
          _buildRecentActivitySection(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, bool isDarkMode) {
    return Row(
      children: [
        Icon(icon, size: 20, color: isDarkMode ? AppColors.primary : Colors.black54),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: isDarkMode ? Colors.white70 : Colors.black54,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isDarkMode ? Colors.transparent : Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.factory_rounded, color: AppColors.primary, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plant Status: Optimal',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Main Unit 01 - Zone A',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPIGrid(BuildContext context, DashModel data, bool isDarkMode) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildAnimatedKPICard(
          'PENDING NOTIFS',
          data.totalNotifications.toString(),
          '+${data.todayNotifications} Today',
          Icons.notification_important_rounded,
          AppColors.primary,
          0.1,
          context,
          isDarkMode,
        ),
        _buildAnimatedKPICard(
          'ACTIVE ORDERS',
          data.totalWorkOrders.toString(),
          '+${data.todayWorkOrders} Today',
          Icons.handyman_rounded,
          AppColors.secondary,
          0.2,
          context,
          isDarkMode,
        ),
        _buildAnimatedKPICard(
          'OVERALL OEE',
          data.oee,
          'Target: 95%',
          Icons.offline_bolt_rounded,
          AppColors.success,
          0.3,
          context,
          isDarkMode,
        ),
        _buildAnimatedKPICard(
          'TOTAL UPTIME',
          data.uptime,
          'Last 30 Days',
          Icons.verified_rounded,
          AppColors.info,
          0.4,
          context,
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildAnimatedKPICard(String title, String value, String subtitle, IconData icon, Color color, double delay, BuildContext context, bool isDarkMode) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: (800 + (delay * 1000)).toInt()),
      builder: (context, val, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - val)),
          child: Opacity(opacity: val, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.1) : color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(isDarkMode ? 0.2 : 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildRecentActivitySection(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        _buildActivityItem(
          'Critical Valve Failure',
          'Reported by AI Diagnostic',
          'Just Now',
          Icons.warning_amber_rounded,
          AppColors.error,
          context,
          isDarkMode,
        ),
        _buildActivityItem(
          'Preventive Maint. #882',
          'Assigned to Team Beta',
          '14 mins ago',
          Icons.event_available_rounded,
          AppColors.info,
          context,
          isDarkMode,
        ),
        _buildActivityItem(
          'Pressure System Check',
          'Completed successfully',
          '1 hr ago',
          Icons.task_alt_rounded,
          AppColors.success,
          context,
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String time, IconData icon, Color color, BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15, color: isDarkMode ? Colors.white : Colors.black87),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(fontSize: 12, color: isDarkMode ? Colors.white70 : Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.outfit(fontSize: 10, color: isDarkMode ? Colors.white54 : Colors.black38, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object err) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
          const SizedBox(height: 16),
          Text('System Error: $err', style: GoogleFonts.outfit()),
        ],
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32))),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: List.generate(4, (_) => Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)))),
            ),
          ],
        ),
      ),
    );
  }
}
