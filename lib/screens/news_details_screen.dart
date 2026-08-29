import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news_model/news_model.dart';
import '../services/favourite_service.dart';

class NewsDetailsScreen extends StatefulWidget {
  final NewsModel article;

  const NewsDetailsScreen({super.key, required this.article});

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  Future<void> openFullArticle() async {
    final value = widget.article.url?.trim();

    if (value == null || value.isEmpty) {
      _showMessage('Article link is not available');
      return;
    }

    final uri = Uri.tryParse(
      value.startsWith('http://') || value.startsWith('https://')
          ? value
          : 'https://$value',
    );

    if (uri == null || uri.host.isEmpty) {
      _showMessage('Invalid article link');
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        _showMessage('Unable to open this article');
      }
    } catch (_) {
      if (mounted) {
        _showMessage('Unable to open this article');
      }
    }
  }

  Future<void> shareArticle() async {
    final value = widget.article.url?.trim();

    if (value == null || value.isEmpty) {
      _showMessage('Article link is not available');
      return;
    }

    try {
      await SharePlus.instance.share(
        ShareParams(text: '${widget.article.title ?? 'News'}\n\n$value'),
      );
    } catch (_) {
      if (mounted) {
        _showMessage('Unable to share this article');
      }
    }
  }

  Future<void> toggleFavorite() async {
    try {
      await FavoritesBox.toggleFavorite(widget.article);

      if (!mounted) {
        return;
      }

      setState(() {});

      final isFavorite = FavoritesBox.isFavorite(widget.article);

      _showMessage(
        isFavorite ? 'Added to favorites' : 'Removed from favorites',
      );
    } catch (_) {
      if (mounted) {
        _showMessage('Unable to update favorites');
      }
    }
  }

  String formatDate(String? date) {
    if (date == null || date.trim().isEmpty) {
      return 'Recent';
    }

    try {
      final parsedDate = DateTime.parse(date);

      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (_) {
      return 'Recent';
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final article = widget.article;

    final hasImage =
        article.urlToImage != null && article.urlToImage!.trim().isNotEmpty;

    final isFavorite = FavoritesBox.isFavorite(article);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'News Details',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: toggleFavorite,
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
            icon: Icon(
              isFavorite
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: isFavorite ? colors.primary : colors.onSurface,
            ),
          ),
          IconButton(
            onPressed: shareArticle,
            tooltip: 'Share',
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              SizedBox(
                width: double.infinity,
                height: 250,
                child: Image.network(
                  article.urlToImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagePlaceholder(context);
                  },
                ),
              )
            else
              _buildImagePlaceholder(context, height: 250),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (article.sourceName != null &&
                          article.sourceName!.trim().isNotEmpty)
                        Expanded(
                          child: Text(
                            article.sourceName!.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.7,
                              color: colors.primary,
                            ),
                          ),
                        )
                      else
                        const Spacer(),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        formatDate(article.publishedAt),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    article.title ?? 'No title available',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontSize: 25,
                      height: 1.2,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: colors.onSurface,
                    ),
                  ),
                  if (article.author != null &&
                      article.author!.trim().isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 17,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'By ${article.author}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (article.description != null &&
                      article.description!.trim().isNotEmpty) ...[
                    const SizedBox(height: 22),
                    Text(
                      article.description!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface,
                      ),
                    ),
                  ],
                  if (article.content != null &&
                      article.content!.trim().isNotEmpty) ...[
                    const SizedBox(height: 22),
                    Text(
                      article.content!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        height: 1.7,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: openFullArticle,
                      icon: const Icon(Icons.open_in_new_rounded, size: 20),
                      label: const Text(
                        'Read Full Article',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context, {double height = 250}) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: height,
      color: colors.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.newspaper_rounded,
          size: 60,
          color: colors.onSurfaceVariant.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}
