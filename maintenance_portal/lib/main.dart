import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/presentation/auth_controller.dart';
import 'features/auth/presentation/login_screen.dart';
import 'shared/widgets/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SAPMaintenancePortal(),
    ),
  );
}

class SAPMaintenancePortal extends ConsumerWidget {
  const SAPMaintenancePortal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isDarkMode = ref.watch(themeProvider);

    print('Building SAPMaintenancePortal: User is ${authState.user != null ? 'LoggedIn' : 'LoggedOut'}');

    return MaterialApp(
      title: 'SAP Maintenance Portal',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: authState.user == null 
          ? const LoginScreen() 
          : const MainScreen(),
    );
  }
}
