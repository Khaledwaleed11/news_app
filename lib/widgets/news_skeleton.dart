import 'package:flutter/material.dart';

class NewsSkeleton extends StatefulWidget {
  const NewsSkeleton({super.key});

  @override
  State<NewsSkeleton> createState() => _NewsSkeletonState();
}

class _NewsSkeletonState extends State<NewsSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.35,
      end: 0.75,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _skeletonBox({
    required double width,
    required double height,
    required Color color,
    double radius = 8,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final skeletonColor = colors.onSurface.withValues(alpha: 0.08);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _skeletonBox(
            width: 100,
            height: 100,
            color: skeletonColor,
            radius: 14,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _skeletonBox(
                    width: 85,
                    height: 11,
                    color: skeletonColor,
                    radius: 5,
                  ),
                  _skeletonBox(
                    width: double.infinity,
                    height: 13,
                    color: skeletonColor,
                    radius: 5,
                  ),
                  _skeletonBox(
                    width: 170,
                    height: 13,
                    color: skeletonColor,
                    radius: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _skeletonBox(
                        width: 22,
                        height: 22,
                        color: skeletonColor,
                        radius: 11,
                      ),
                      const SizedBox(width: 10),
                      _skeletonBox(
                        width: 22,
                        height: 22,
                        color: skeletonColor,
                        radius: 11,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewsSkeletonText extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double radius;

  const NewsSkeletonText({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
