import 'package:flutter/material.dart';
import 'package:news_app/screens/search_screen.dart';

import '../api_service/remote_data_source.dart';
import '../models/news_model/news_model.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/news_item.dart';
import '../widgets/news_skeleton.dart';
import '../widgets/search_button.dart';
import 'favourite_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RemoteDataSource remoteDataSource = RemoteDataSource();

  List<NewsModel> news = [];

  bool isLoading = true;
  String? errorMessage;

  String selectedCategory = 'business';

  @override
  void initState() {
    super.initState();
    getNews();
  }

  Future<void> getNews() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await remoteDataSource.getNewsByCategory(selectedCategory);

      final articles = data['articles'];

      final loadedNews = articles is List
          ? articles
                .whereType<Map>()
                .map(
                  (article) =>
                      NewsModel.fromJson(Map<String, dynamic>.from(article)),
                )
                .toList()
          : <NewsModel>[];

      if (!mounted) return;

      setState(() {
        news = loadedNews;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        news = [];
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> changeCategory(String category) async {
    if (selectedCategory == category) {
      return;
    }

    setState(() {
      selectedCategory = category;
    });

    await getNews();
  }

  String getCategoryTitle() {
    switch (selectedCategory) {
      case 'business':
        return 'Business News';
      case 'entertainment':
        return 'Entertainment';
      case 'general':
        return 'General News';
      case 'health':
        return 'Health News';
      case 'science':
        return 'Science News';
      case 'sports':
        return 'Sports News';
      case 'technology':
        return 'Technology News';
      default:
        return 'Latest News';
    }
  }

  void openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  void openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'News App',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        actions: [
          SearchButton(onPressed: openSearch),
          IconButton(
            onPressed: widget.onThemeToggle,
            tooltip: widget.isDarkMode
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Icon(
                widget.isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                key: ValueKey(widget.isDarkMode),
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(colors),
      bottomNavigationBar: CategoryBottomNav(
        selectedCategory: selectedCategory,
        onCategorySelected: changeCategory,
        onFavoritesPressed: openFavorites,
        isFavoritesSelected: false,
      ),
    );
  }

  Widget _buildBody(ColorScheme colors) {
    if (isLoading) {
      return _buildLoading();
    }

    if (errorMessage != null) {
      return _buildError();
    }

    if (news.isEmpty) {
      return _buildEmpty();
    }

    return RefreshIndicator(
      onRefresh: getNews,
      displacement: 20,
      color: colors.primary,
      backgroundColor: colors.surface,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          _buildHeader(),
          const SizedBox(height: 22),
          ...List.generate(
            news.length,
            (index) => NewsItem(article: news[index], animationIndex: index),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getCategoryTitle(),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Discover the latest stories from around the world.',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            height: 1.4,
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bolt_rounded, size: 18, color: colors.primary),
              const SizedBox(width: 7),
              Text(
                '${news.length} stories available',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    final colors = Theme.of(context).colorScheme;

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      children: [
        NewsSkeletonText(
          width: 190,
          height: 30,
          color: colors.onSurface.withValues(alpha: 0.08),
        ),
        const SizedBox(height: 10),
        NewsSkeletonText(
          width: 280,
          height: 14,
          color: colors.onSurface.withValues(alpha: 0.08),
        ),
        const SizedBox(height: 18),
        NewsSkeletonText(
          width: 145,
          height: 38,
          color: colors.primary.withValues(alpha: 0.08),
          radius: 14,
        ),
        const SizedBox(height: 22),
        const NewsSkeleton(),
        const NewsSkeleton(),
        const NewsSkeleton(),
        const NewsSkeleton(),
      ],
    );
  }

  Widget _buildError() {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: colors.error.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 42,
                color: colors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              errorMessage ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn’t load the latest ${getCategoryTitle().toLowerCase()}.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.5,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: getNews,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(
                  'Try Again',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
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
                color: colors.onSurface.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.article_outlined,
                size: 48,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No News Available',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'There are no articles to show right now.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 22),
            OutlinedButton.icon(
              onPressed: getNews,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Refresh',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
