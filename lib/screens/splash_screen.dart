import 'dart:async';

import 'package:flutter/material.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const SplashScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final AnimationController _backgroundController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _textFade;

  Timer? _textTimer;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeOut);

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.40), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeOut);

    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _logoController.forward();

    _textTimer = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        _textController.forward();
      }
    });

    _navigationTimer = Timer(const Duration(milliseconds: 2400), _openHome);
  }

  void _openHome() {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) {
          return HomeScreen(
            onThemeToggle: widget.onThemeToggle,
            isDarkMode: widget.isDarkMode,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curve = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curve,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1.0).animate(curve),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _textTimer?.cancel();
    _navigationTimer?.cancel();

    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = widget.isDarkMode;

    final backgroundStart = isDark
        ? const Color(0xFF0B1220)
        : const Color(0xFFF7FAFF);

    final backgroundEnd = isDark
        ? const Color(0xFF101827)
        : const Color(0xFFEAF2FF);

    final mainTextColor = isDark ? Colors.white : const Color(0xFF111827);

    final secondaryTextColor = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          final value = _backgroundController.value;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1 + value * 0.4, -1),
                end: Alignment(1, 1 - value * 0.4),
                colors: [backgroundStart, backgroundEnd],
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -100,
                right: -80,
                child: _buildBlurCircle(
                  size: 240,
                  color: colors.primary.withValues(alpha: isDark ? 0.10 : 0.08),
                ),
              ),
              Positioned(
                bottom: -120,
                left: -90,
                child: _buildBlurCircle(
                  size: 260,
                  color: colors.primary.withValues(alpha: isDark ? 0.08 : 0.06),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: colors.primary.withValues(alpha: 0.28),
                                blurRadius: 30,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.newspaper_rounded,
                            size: 58,
                            color: colors.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    FadeTransition(
                      opacity: _textFade,
                      child: SlideTransition(
                        position: _textSlide,
                        child: Column(
                          children: [
                            Text(
                              'News App',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.2,
                                color: mainTextColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Stay informed. Stay ahead.',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 28,
                child: FadeTransition(
                  opacity: _textFade,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Loading latest stories...',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlurCircle({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
