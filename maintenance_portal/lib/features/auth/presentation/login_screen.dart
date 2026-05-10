import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/fluid_background.dart'; // Still named fluid_background.dart but class is GalaxyBackground
import '../../../core/theme/theme_provider.dart';
import 'auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _empidController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _empidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isDarkMode = ref.watch(themeProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error.withOpacity(0.8),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF0F4F8),
      body: Stack(
        children: [
          GalaxyBackground(isDarkMode: isDarkMode),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildCosmicCard(authState, isDarkMode),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCosmicCard(AuthState authState, bool isDarkMode) {
    return Container(
      width: 420,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.purple.withOpacity(0.1) : Colors.black.withOpacity(0.05),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 64.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCosmicHeader(isDarkMode),
              const SizedBox(height: 56),
              _buildCosmicTextField(
                controller: _empidController,
                label: 'USER IDENTIFIER',
                hint: 'EMP 2001',
                icon: Icons.api_rounded,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 24),
              _buildCosmicTextField(
                controller: _passwordController,
                label: 'ACCESS CODE',
                hint: '••••••••',
                icon: Icons.key_off_rounded,
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onToggleVisibility: () =>
                    setState(() => _isPasswordVisible = !_isPasswordVisible),
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 56),
              _buildCosmicButton(authState),
              const SizedBox(height: 40),
              _buildSystemStatus(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCosmicHeader(bool isDarkMode) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.cyanAccent, Colors.purpleAccent],
          ).createShader(bounds),
          child: const Icon(
            Icons.blur_on_rounded,
            size: 64,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'PLANT MAINTENANCE PORTAL',
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: isDarkMode ? Colors.white : const Color(0xFF1A237E),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'MAINTENANCE NETWORK ACCESS',
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 10,
            color: isDarkMode ? Colors.white54 : Colors.black45,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildCosmicTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: isDarkMode ? Colors.cyanAccent.withOpacity(0.7) : const Color(0xFF2575FC),
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            style: GoogleFonts.spaceGrotesk(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
              letterSpacing: isPassword && !isPasswordVisible ? 4 : 0.5,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: isDarkMode ? Colors.white30 : Colors.black26, size: 20),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: isDarkMode ? Colors.white30 : Colors.black26,
                        size: 18,
                      ),
                      onPressed: onToggleVisibility,
                    )
                  : null,
              hintText: hint,
              hintStyle: GoogleFonts.spaceGrotesk(
                color: isDarkMode ? Colors.white10 : Colors.black12,
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCosmicButton(AuthState authState) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: authState.isLoading
            ? null
            : () {
                ref
                    .read(authProvider.notifier)
                    .login(_empidController.text, _passwordController.text);
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: authState.isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'INITIALIZE ACCESS',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
      ),
    );
  }

  Widget _buildSystemStatus(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.greenAccent : Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'SECURE CONNECTION STABLE',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 9,
            color: isDarkMode ? Colors.white30 : Colors.black26,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
