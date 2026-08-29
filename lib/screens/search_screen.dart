import 'package:flutter/material.dart';

import '../api_service/remote_data_source.dart';
import '../models/news_model/news_model.dart';
import '../widgets/news_item.dart';
import '../widgets/news_skeleton.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final RemoteDataSource remoteDataSource = RemoteDataSource();

  final TextEditingController searchController = TextEditingController();

  final FocusNode searchFocusNode = FocusNode();

  List<NewsModel> searchResults = [];

  bool isLoading = false;
  bool isSearched = false;

  String? errorMessage;

  static const List<String> quickSearchQuery = [
    'Technology',
    'AI',
    'Flutter',
    'Crypto',
    'Sports',
  ];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> searchNews([String? query]) async {
    final searchKeyword = (query ?? searchController.text).trim();

    if (searchKeyword.isEmpty || isLoading) {
      return;
    }

    if (query != null) {
      searchController.text = searchKeyword;
      searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: searchController.text.length),
      );
    }

    searchFocusNode.unfocus();

    setState(() {
      isLoading = true;
      isSearched = true;
      errorMessage = null;
      searchResults = [];
    });

    try {
      final data = await remoteDataSource.searchNews(searchKeyword);

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

      if (!mounted) {
        return;
      }

      setState(() {
        searchResults = loadedNews;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
        searchResults = [];
      });
    }
  }

  void clearSearch() {
    searchController.clear();

    if (!mounted) {
      return;
    }

    setState(() {
      searchResults = [];
      errorMessage = null;
      isSearched = false;
      isLoading = false;
    });

    searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Search News',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchField(colors),
            _buildSearchButton(colors),
            const SizedBox(height: 12),
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => searchNews(),
        style: TextStyle(color: colors.onSurface, fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Search topic, keyword or source...',
          hintStyle: TextStyle(
            color: colors.onSurfaceVariant.withValues(alpha: 0.7),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: colors.primary,
            size: 22,
          ),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: clearSearch,
                  icon: Icon(
                    Icons.cancel_rounded,
                    color: colors.onSurfaceVariant,
                    size: 20,
                  ),
                )
              : null,
          filled: true,
          fillColor: colors.surfaceContainerLow,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: colors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: colors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: colors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: FilledButton.icon(
          onPressed: isLoading ? null : searchNews,
          style: FilledButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: isLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.onPrimary,
                  ),
                )
              : const Icon(Icons.search_rounded, size: 20),
          label: Text(
            isLoading ? 'Searching...' : 'Search',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (isLoading) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: 5,
        itemBuilder: (context, index) {
          return const NewsSkeleton();
        },
      );
    }

    if (errorMessage != null) {
      return _buildErrorState(theme, colors);
    }

    if (!isSearched) {
      return _buildInitialState(theme, colors);
    }

    if (searchResults.isEmpty) {
      return _buildNoResultsState(theme, colors);
    }

    return RefreshIndicator(
      onRefresh: searchNews,
      color: colors.primary,
      backgroundColor: colors.surface,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return NewsItem(article: searchResults[index], animationIndex: index);
        },
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, ColorScheme colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.errorContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: colors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Search Failed',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Could not load search results. Check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: isLoading ? null : searchNews,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState(ThemeData theme, ColorScheme colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.primaryContainer.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.travel_explore_rounded,
              size: 40,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Explore Global Topics',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Type keywords above or pick a quick search topic.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: quickSearchQuery.map((query) {
              return ActionChip(
                label: Text(query),
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                ),
                backgroundColor: colors.surfaceContainerLow,
                side: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.3),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: isLoading ? null : () => searchNews(query),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(ThemeData theme, ColorScheme colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: colors.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Results Found',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'We couldn\'t find any news matching "${searchController.text}".',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: clearSearch,
              icon: const Icon(Icons.search_rounded, size: 18),
              label: const Text('Search Again'),
            ),
          ],
        ),
      ),
    );
  }
}
