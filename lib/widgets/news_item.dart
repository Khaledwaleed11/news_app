import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news_model/news_model.dart';
import '../screens/news_details_screen.dart';
import '../services/favourite_service.dart';

class NewsItem extends StatefulWidget {
  final NewsModel article;
  final int animationIndex;

  const NewsItem({super.key, required this.article, this.animationIndex = 0});

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    final delay = Duration(milliseconds: 70 * widget.animationIndex);
    if (delay == Duration.zero) {
      _controller.forward();
    } else {
      _animationTimer = Timer(delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  Future<void> openNews() async {
    final value = widget.article.url?.trim();
    if (value == null || value.isEmpty) {
      return;
    }
    final uri = Uri.tryParse(
      value.startsWith('http://') || value.startsWith('https://')
          ? value
          : 'https://$value',
    );
    if (uri == null || uri.host.isEmpty) {
      return;
    }
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  Future<void> shareNews() async {
    final url = widget.article.url?.trim();
    if (url == null || url.isEmpty) {
      return;
    }
    await SharePlus.instance.share(
      ShareParams(text: '${widget.article.title ?? 'News'}\n\n$url'),
    );
  }

  void openDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewsDetailsScreen(article: widget.article),
      ),
    );
  }

  Future<void> toggleFavorite() async {
    await FavoritesBox.toggleFavorite(widget.article);
    if (!mounted) {
      return;
    }
    setState(() {});
    final isFavorite = FavoritesBox.isFavorite(widget.article);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(
          isFavorite ? 'Added to favorites' : 'Removed from favorites',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String formatDate(String? date) {
    if (date == null || date.trim().isEmpty) {
      return 'Recent';
    }
    try {
      final parsedDate = DateTime.parse(date);
      final difference = DateTime.now().difference(parsedDate);
      if (difference.inMinutes < 1) {
        return 'Just now';
      }
      if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      }
      if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      }
      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (_) {
      return 'Recent';
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final article = widget.article;
    final hasImage =
        article.urlToImage != null && article.urlToImage!.trim().isNotEmpty;
    final isFavorite = FavoritesBox.isFavorite(article);
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: openDetails,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag:
                          article.url ??
                          '${article.title}_image_${widget.animationIndex}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 108,
                          height: 108,
                          child: hasImage
                              ? Image.network(
                                  article.urlToImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildImagePlaceholder(context);
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container(
                                          color: colors.surfaceContainerHighest,
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        );
                                      },
                                )
                              : _buildImagePlaceholder(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SizedBox(
                        height: 108,
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
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.6,
                                        color: colors.primary,
                                      ),
                                    ),
                                  )
                                else
                                  const Spacer(),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 12,
                                  color: colors.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  formatDate(article.publishedAt),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                article.title ?? 'No title available',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.3,
                                  fontWeight: FontWeight.w800,
                                  color: colors.onSurface,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _ActionButton(
                                  icon: isFavorite
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_border_rounded,
                                  color: isFavorite
                                      ? colors.primary
                                      : colors.onSurfaceVariant,
                                  onTap: toggleFavorite,
                                ),
                                const SizedBox(width: 4),
                                _ActionButton(
                                  icon: Icons.share_outlined,
                                  color: colors.onSurfaceVariant,
                                  onTap: shareNews,
                                ),
                                const SizedBox(width: 4),
                                Material(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                    onTap: openDetails,
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: 34,
                                      height: 34,
                                      child: Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 18,
                                        color: colors.onPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: colors.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.newspaper_rounded,
          size: 34,
          color: colors.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 19, color: color),
        ),
      ),
    );
  }
}
