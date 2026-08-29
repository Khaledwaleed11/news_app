import 'package:flutter/material.dart';

class CategoryBottomNav extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback onFavoritesPressed;
  final bool isFavoritesSelected;

  const CategoryBottomNav({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onFavoritesPressed,
    required this.isFavoritesSelected,
  });

  static const List<CategoryData> categories = [
    CategoryData(
      name: 'business',
      title: 'Business',
      icon: Icons.business_center_rounded,
    ),
    CategoryData(
      name: 'entertainment',
      title: 'Entertainment',
      icon: Icons.movie_rounded,
    ),
    CategoryData(name: 'general', title: 'General', icon: Icons.public_rounded),
    CategoryData(
      name: 'health',
      title: 'Health',
      icon: Icons.health_and_safety_rounded,
    ),
    CategoryData(
      name: 'science',
      title: 'Science',
      icon: Icons.science_rounded,
    ),
    CategoryData(
      name: 'sports',
      title: 'Sports',
      icon: Icons.sports_soccer_rounded,
    ),
    CategoryData(
      name: 'technology',
      title: 'Tech',
      icon: Icons.computer_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.30)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            itemCount: categories.length + 1,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildFavoritesItem(colors);
              }

              final category = categories[index - 1];

              return _buildCategoryItem(colors, category);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesItem(ColorScheme colors) {
    return Material(
      color: isFavoritesSelected ? colors.primary : colors.surfaceContainerLow,
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
              if (isFavoritesSelected) ...[
                const SizedBox(width: 7),
                Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: colors.onPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(ColorScheme colors, CategoryData category) {
    final isSelected =
        !isFavoritesSelected && selectedCategory == category.name;

    return Material(
      color: isSelected ? colors.primary : colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: () => onCategorySelected(category.name),
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
                category.icon,
                size: 19,
                color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
              ),
              if (isSelected) ...[
                const SizedBox(width: 7),
                Text(
                  category.title,
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
    );
  }
}

class CategoryData {
  final String name;
  final String title;
  final IconData icon;

  const CategoryData({
    required this.name,
    required this.title,
    required this.icon,
  });
}
