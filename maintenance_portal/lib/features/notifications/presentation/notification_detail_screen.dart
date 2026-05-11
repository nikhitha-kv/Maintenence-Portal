import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../models/notification_model.dart';
import '../../../core/utils/date_formatter.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(context),
                  const SizedBox(height: 30),
                  _buildDetailSection(context),
                  const SizedBox(height: 30),
                  _buildHistoryTimeline(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      centerTitle: false,
      title: Text(
        'Notif #${notification.qmnum}',
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black26
                : Colors.black.withOpacity(0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                notification.qmart,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'OPEN',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            notification.qmtxt,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Technical Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildDetailRow(context, 'Equipment', notification.qmnam),
        _buildDetailRow(context, 'Start Date', notification.strmn),
        _buildDetailRow(
          context,
          'Creation Date',
          DateFormatter.formatSAPDate(notification.erdat),
        ),
        _buildDetailRow(context, 'Created By', notification.ernam),
        _buildDetailRow(
          context,
          'Last Modified',
          DateFormatter.formatSAPDate(notification.aedat),
        ),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white38
                  : Colors.grey[600],
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildHistoryTimeline(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lifecycle History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildTimelineItem(
          context,
          'Notification Created',
          DateFormatter.formatSAPDate(notification.erdat),
          notification.ernam,
          true,
        ),
        _buildTimelineItem(
          context,
          'Priority Assigned',
          DateFormatter.formatSAPDate(notification.erdat),
          'System',
          false,
        ),
        _buildTimelineItem(
          context,
          'Last Update Detected',
          DateFormatter.formatSAPDate(notification.aedat),
          notification.aenam,
          false,
        ),
      ],
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String title,
    String date,
    String user,
    bool isLast,
  ) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$date by $user',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white38
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
