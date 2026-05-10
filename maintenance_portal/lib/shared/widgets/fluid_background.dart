import 'dart:math' as math;
import 'package:flutter/material.dart';

class GalaxyBackground extends StatefulWidget {
  final bool showStars;
  final bool isDarkMode;
  const GalaxyBackground({super.key, this.showStars = true, this.isDarkMode = true});

  @override
  State<GalaxyBackground> createState() => _GalaxyBackgroundState();
}

class _GalaxyBackgroundState extends State<GalaxyBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    // Generate static stars
    for (int i = 0; i < 150; i++) {
      _stars.add(Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2,
        opacity: _random.nextDouble(),
        twinkleSpeed: _random.nextDouble() * 0.05 + 0.01,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: GalaxyPainter(_controller.value, _stars, widget.showStars, widget.isDarkMode),
          child: Container(),
        );
      },
    );
  }
}

class Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double twinkleSpeed;

  Star({required this.x, required this.y, required this.size, required this.opacity, required this.twinkleSpeed});
}

class GalaxyPainter extends CustomPainter {
  final double animationValue;
  final List<Star> stars;
  final bool showStars;
  final bool isDarkMode;

  GalaxyPainter(this.animationValue, this.stars, this.showStars, this.isDarkMode);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Background Colors
    if (isDarkMode) {
      const Gradient bgGradient = RadialGradient(
        center: Alignment.center,
        radius: 1.5,
        colors: [
          Color(0xFF0D0D1F), // Deep Navy
          Color(0xFF05050A), // Near Black
          Color(0xFF000000), // Pure Black
        ],
      );
      canvas.drawRect(rect, Paint()..shader = bgGradient.createShader(rect));
    } else {
      // Light Mode Background
      const Gradient bgGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFF0F4F8), // Soft Blue-Grey
          Color(0xFFE1E8F0), 
          Color(0xFFFFFFFF),
        ],
      );
      canvas.drawRect(rect, Paint()..shader = bgGradient.createShader(rect));
    }

    final paint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80);

    // Nebula Colors
    final List<Color> nebulaColors;
    if (isDarkMode) {
      nebulaColors = [
        const Color(0xFF4A148C).withOpacity(0.3), // Deep Purple
        const Color(0xFF880E4F).withOpacity(0.2), // Deep Pink
        const Color(0xFF01579B).withOpacity(0.2), // Deep Blue
        const Color(0xFF006064).withOpacity(0.15), // Deep Teal
      ];
    } else {
      // Light Mode Nebula (Pastel)
      nebulaColors = [
        const Color(0xFFE1F5FE).withOpacity(0.4), // Pastel Blue
        const Color(0xFFF3E5F5).withOpacity(0.4), // Pastel Purple
        const Color(0xFFE0F2F1).withOpacity(0.4), // Pastel Teal
        const Color(0xFFFFF9C4).withOpacity(0.2), // Pastel Yellow
      ];
    }

    // Draw Nebulae
    for (int i = 0; i < nebulaColors.length; i++) {
      final double phase = (i / nebulaColors.length) * 2 * math.pi;
      final double x = size.width / 2 + 
          math.sin(animationValue * 2 * math.pi + phase) * (size.width * 0.4);
      final double y = size.height / 2 + 
          math.cos(animationValue * 3 * math.pi + phase * 1.5) * (size.height * 0.3);
      
      final double radius = size.width * 0.8 + 
          math.sin(animationValue * math.pi + phase) * (size.width * 0.2);

      paint.shader = RadialGradient(
        colors: [
          nebulaColors[i],
          nebulaColors[i].withOpacity(0),
        ],
      ).createShader(Rect.fromCircle(center: Offset(x, y), radius: radius));

      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw Stars only if showStars is true AND isDarkMode is true
    if (showStars && isDarkMode) {
      final starPaint = Paint()..color = Colors.white;
      for (var star in stars) {
        final double twinkle = (math.sin(animationValue * 2 * math.pi / star.twinkleSpeed) + 1) / 2;
        starPaint.color = Colors.white.withOpacity(star.opacity * twinkle);
        canvas.drawCircle(
          Offset(star.x * size.width, star.y * size.height),
          star.size,
          starPaint,
        );
      }
    }
    
    // Distant Glows (only in Dark Mode)
    if (isDarkMode) {
      final glowPaint = Paint()..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      for (int i = 0; i < 3; i++) {
         final double x = size.width * (0.2 + 0.6 * math.sin(animationValue * math.pi + i));
         final double y = size.height * (0.2 + 0.6 * math.cos(animationValue * 0.5 * math.pi + i));
         glowPaint.color = (i == 0 ? Colors.blue : (i == 1 ? Colors.purple : Colors.pink)).withOpacity(0.1);
         canvas.drawCircle(Offset(x, y), 100, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant GalaxyPainter oldDelegate) => true;
}
