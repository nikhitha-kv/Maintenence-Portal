import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../auth/presentation/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Profile Settings', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileCard(user?.empid ?? 'N/A', isDarkMode),
            const SizedBox(height: 30),
            _buildSettingsSection(context, ref, isDarkMode),
            const SizedBox(height: 30),
            _buildAppInfo(isDarkMode),
            const SizedBox(height: 40),
            _buildLogoutButton(ref),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(String empid, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.05)),
        boxShadow: isDarkMode ? [] : [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: isDarkMode ? Colors.white24 : AppColors.primary.withOpacity(0.1),
            child: Icon(Icons.person, size: 40, color: isDarkMode ? Colors.white : AppColors.primary),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Maintenance Engineer',
                  style: GoogleFonts.outfit(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Employee ID: $empid',
                  style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white.withOpacity(0.2) : AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Active Session',
                    style: TextStyle(color: isDarkMode ? Colors.white : AppColors.success, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87),
        ),
        const SizedBox(height: 16),
        _buildSettingsTile(
          context,
          isDarkMode ? 'Light Theme' : 'Dark Theme',
          'Switch between light and dark aesthetics',
          isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          isDarkMode: isDarkMode,
          trailing: Switch(
            value: !isDarkMode,
            onChanged: (val) => ref.read(themeProvider.notifier).toggleTheme(),
            activeColor: AppColors.secondary,
          ),
          onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
        ),
        _buildSettingsTile(
          context,
          'Notifications',
          'Manage app notifications',
          Icons.notifications_active_outlined,
          isDarkMode: isDarkMode,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notification settings coming soon...')),
          ),
        ),
        _buildSettingsTile(
          context,
          'Security',
          'Biometric login and PIN',
          Icons.security_outlined,
          isDarkMode: isDarkMode,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Security settings coming soon...')),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
    required bool isDarkMode,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              trailing ?? Icon(Icons.chevron_right, color: isDarkMode ? Colors.white24 : Colors.black26, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppInfo(bool isDarkMode) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Text(
          'SAP Maintenance Portal',
          style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white60 : Colors.black38),
        ),
        Text(
          'Version 1.0.0 (Production)',
          style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white54 : Colors.black26),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.health_and_safety_outlined, size: 14, color: AppColors.success),
            const SizedBox(width: 4),
            Text(
              'API Systems Online',
              style: TextStyle(fontSize: 12, color: AppColors.success.withOpacity(0.8)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutButton(WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: () => ref.read(authProvider.notifier).logout(),
        icon: const Icon(Icons.logout, color: AppColors.error),
        label: const Text(
          'LOGOUT SESSION',
          style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.error),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}
