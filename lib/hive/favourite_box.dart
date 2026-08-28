import 'package:flutter/material.dart';
import 'package:news_app/screens/search_screen.dart';

import '../api_service/remote_data_source.dart';
import '../models/news_model/news_model.dart';
import '../screens/favourite_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/news_item.dart';
import '../widgets/search_button.dart';

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

  final List<String> categories = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  @override
  void initState() {
    super.initState();

    getNews();
  }

  Future<void> getNews() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final data = await remoteDataSource.getNewsByCategory(selectedCategory);

      final List articles = data['articles'] ?? [];

      final List<NewsModel> loadedNews = articles
          .map((article) => NewsModel.fromJson(article))
          .toList();

      if (!mounted) return;

      setState(() {
        news = loadedNews;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text(
          'News App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

        actions: [
          SearchButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),

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

      body: _buildBody(),

      bottomNavigationBar: CategoryBottomNav(
        selectedCategory: selectedCategory,
        onCategorySelected: changeCategory,
        onFavoritesPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoritesScreen()),
          );
        },
        isFavoritesSelected: false,
      ),
    );
  }

  Widget _buildBody() {
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

      color: Theme.of(context).colorScheme.primary,

      backgroundColor: Theme.of(context).colorScheme.surface,

      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

        children: [
          _buildHeader(),

          const SizedBox(height: 22),

          ...List.generate(news.length, (index) {
            return NewsItem(article: news[index]);
          }),
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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            width: 70,
            height: 70,

            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.10),

              shape: BoxShape.circle,
            ),

            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: colors.primary,
              ),
            ),
          ),

          const SizedBox(height: 22),

          Text(
            'Loading ${getCategoryTitle()}...',

            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: colors.onSurface,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Please wait a moment',

            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 13,
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
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
                fontSize: 13,
                height: 1.5,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              'We couldn’t load the latest news.\n'
              'Please check your connection and try again.',

              textAlign: TextAlign.center,

              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.5,
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              height: 50,

              child: ElevatedButton.icon(
                onPressed: getNews,

                style: ElevatedButton.styleFrom(
                  elevation: 0,

                  padding: const EdgeInsets.symmetric(horizontal: 24),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

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
              'No news available',

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

              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

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
