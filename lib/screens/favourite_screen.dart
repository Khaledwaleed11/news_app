import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/news_model/news_model.dart';
import '../services/favourite_service.dart';
import '../widgets/news_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),

      body: ValueListenableBuilder(
        valueListenable: FavoritesBox.box.listenable(),

        builder: (context, Box box, _) {
          final List<NewsModel> favorites = FavoritesBox.getFavorites();

          if (favorites.isEmpty) {
            return _buildEmpty(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),

            physics: const BouncingScrollPhysics(),

            itemCount: favorites.length,

            itemBuilder: (context, index) {
              return NewsItem(article: favorites[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 100,
              height: 100,

              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.bookmark_border_rounded,
                size: 48,
                color: colors.primary,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'No Favorites Yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Save interesting news here to read it later.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.5,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
