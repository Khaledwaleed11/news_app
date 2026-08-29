import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SearchButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.primaryContainer.withValues(alpha: 0.40),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.30),
              ),
            ),
            child: Icon(Icons.search_rounded, color: colors.primary, size: 22),
          ),
        ),
      ),
    );
  }
}
