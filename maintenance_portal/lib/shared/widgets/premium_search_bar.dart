import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class PremiumSearchBar extends StatefulWidget {
  final String initialValue;
  final String hintText;
  final Function(String) onChanged;
  final VoidCallback onFilterTap;
  final bool hasActiveFilters;

  const PremiumSearchBar({
    super.key,
    required this.initialValue,
    required this.hintText,
    required this.onChanged,
    required this.onFilterTap,
    this.hasActiveFilters = false,
  });

  @override
  State<PremiumSearchBar> createState() => _PremiumSearchBarState();
}

class _PremiumSearchBarState extends State<PremiumSearchBar> with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  Timer? _debounce;
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onChanged(value);
    });
    setState(() {}); // For clear button visibility
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _isFocused 
            ? (isDark ? Colors.white.withOpacity(0.08) : Colors.white)
            : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isFocused ? AppColors.primary.withOpacity(0.5) : Colors.transparent,
          width: 2,
        ),
        boxShadow: _isFocused ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ] : [],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(
            Icons.search_rounded,
            color: _isFocused ? AppColors.primary : Colors.grey[500],
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: _onChanged,
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: GoogleFonts.outfit(
                  color: Colors.grey[500],
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.close_rounded, size: 20, color: Colors.grey[500]),
              onPressed: () {
                _controller.clear();
                _onChanged('');
              },
            ),
          const SizedBox(width: 4),
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.tune_rounded,
                  color: widget.hasActiveFilters ? AppColors.secondary : Colors.grey[500],
                  size: 22,
                ),
                onPressed: widget.onFilterTap,
              ),
              if (widget.hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
