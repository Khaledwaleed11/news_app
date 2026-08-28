import 'package:flutter/material.dart';

class CategoryBottomNav extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  final VoidCallback onFavoritesPressed;
  final bool isFavoritesSelected;

  const CategoryBottomNav({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onFavoritesPressed,
    required this.isFavoritesSelected,
  });

  final List<Map<String, dynamic>> categories = const [
    {
      'name': 'business',
      'title': 'Business',
      'icon': Icons.business_center_rounded,
    },
    {
      'name': 'entertainment',
      'title': 'Entertainment',
      'icon': Icons.movie_rounded,
    },
    {'name': 'general', 'title': 'General', 'icon': Icons.public_rounded},
    {
      'name': 'health',
      'title': 'Health',
      'icon': Icons.health_and_safety_rounded,
    },
    {'name': 'science', 'title': 'Science', 'icon': Icons.science_rounded},
    {'name': 'sports', 'title': 'Sports', 'icon': Icons.sports_soccer_rounded},
    {'name': 'technology', 'title': 'Tech', 'icon': Icons.computer_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,

        border: Border(
          top: BorderSide(
            color: colors.outlineVariant.withValues(alpha: 0.3),

            width: 1,
          ),
        ),
      ),

      child: SafeArea(
        top: false,

        child: SizedBox(
          height: 64,

          child: ListView(
            scrollDirection: Axis.horizontal,

            physics: const BouncingScrollPhysics(),

            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),

                child: Material(
                  color: isFavoritesSelected
                      ? colors.primary
                      : colors.surfaceContainerLow,

                  borderRadius: BorderRadius.circular(30),

                  child: InkWell(
                    onTap: onFavoritesPressed,

                    borderRadius: BorderRadius.circular(30),

                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isFavoritesSelected ? 16 : 14,

                        vertical: 8,
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          Icon(
                            isFavoritesSelected
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,

                            size: 19,

                            color: isFavoritesSelected
                                ? colors.onPrimary
                                : colors.onSurfaceVariant,
                          ),

                          if (isFavoritesSelected) const SizedBox(width: 7),

                          if (isFavoritesSelected)
                            Text(
                              'Favorites',

                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: colors.onPrimary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              ...categories.map((category) {
                final String name = category['name'];

                final String title = category['title'];

                final IconData icon = category['icon'];

                final bool isSelected =
                    !isFavoritesSelected && selectedCategory == name;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),

                  child: Material(
                    color: isSelected
                        ? colors.primary
                        : colors.surfaceContainerLow,

                    borderRadius: BorderRadius.circular(30),

                    child: InkWell(
                      onTap: () => onCategorySelected(name),

                      borderRadius: BorderRadius.circular(30),

                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSelected ? 16 : 14,
                          vertical: 8,
                        ),

                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Icon(
                              icon,
                              size: 19,

                              color: isSelected
                                  ? colors.onPrimary
                                  : colors.onSurfaceVariant,
                            ),

                            if (isSelected) ...[
                              const SizedBox(width: 7),

                              Text(
                                title,

                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: colors.onPrimary,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
