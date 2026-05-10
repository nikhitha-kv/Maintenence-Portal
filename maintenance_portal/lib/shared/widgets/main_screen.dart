import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/notifications/presentation/notification_list_screen.dart';
import '../../features/work_orders/presentation/work_order_list_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import 'fluid_background.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static const List<Widget> _pages = [
    DashboardScreen(),
    NotificationListScreen(),
    WorkOrderListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Building MainScreen...');
    final selectedIndex = ref.watch(navigationIndexProvider);
    final isDarkMode = ref.watch(themeProvider);

    return Stack(
      children: [
        GalaxyBackground(showStars: false, isDarkMode: isDarkMode),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 600),
            reverse: selectedIndex < (ref.read(navigationIndexProvider)),
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
              return SharedAxisTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                fillColor: Colors.transparent,
                child: child,
              );
            },
            child: _pages[selectedIndex],
          ),
          bottomNavigationBar: _buildModernNavBar(context, ref, selectedIndex),
        ),
      ],
    );
  }

  Widget _buildModernNavBar(BuildContext context, WidgetRef ref, int selectedIndex) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.05),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.black54 
                : Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(context, ref, 0, Icons.dashboard_rounded, 'Dash', selectedIndex),
              _buildNavItem(context, ref, 1, Icons.notifications_rounded, 'Notifs', selectedIndex),
              _buildNavItem(context, ref, 2, Icons.engineering_rounded, 'Orders', selectedIndex),
              _buildNavItem(context, ref, 3, Icons.person_rounded, 'Profile', selectedIndex),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, WidgetRef ref, int index, IconData icon, String label, int selectedIndex) {
    final isSelected = selectedIndex == index;
    
    return GestureDetector(
      onTap: () => ref.read(navigationIndexProvider.notifier).state = index,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? AppColors.primary 
                  : (Theme.of(context).brightness == Brightness.dark ? Colors.white38 : Colors.grey[400]),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
