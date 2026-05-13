import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

/// Grab-style splash screen: minimalist, dark theme, with smooth slide-out
/// transition to the home screen after pre-loading background tasks.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _ready = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeIn),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-1, 0)).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 1, curve: Curves.easeInOutCubic),
          ),
        );

    _controller.forward();
    _preloadAndNavigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Pre-load background tasks and wait a minimum display time,
  /// then slide out to the appropriate screen.
  Future<void> _preloadAndNavigate() async {
    // Run background tasks in parallel
    await Future.wait([
      SharedPreferences.getInstance(),
      // Auth is already initialized in main(); just check current state
      _checkAuthState(),
    ]).catchError((_) {
      // Ignore individual task failures — the app can still work in
      // limited mode.
      return <void>[];
    });

    // Minimum 1 second splash display for perceived polish
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _ready = true);

    // Start slide-out animation
    await _controller.animateTo(1);

    if (!mounted) return;

    // Navigate based on auth state
    final isAuthenticated = ref.read(isAuthenticatedProvider);
    if (isAuthenticated) {
      context.go('/');
    } else {
      context.go('/login');
    }
  }

  Future<void> _checkAuthState() async {
    // Force evaluation of the auth provider so the redirect
    // decision is based on fresh data.
    ref.read(isAuthenticatedProvider);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.background,
                      Color(0xFF0A0A20),
                      AppColors.background,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // App logo — gradient circle + globe icon
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.public,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppSizes.lg),

                        // Stylized "Halo" text with gradient
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              AppColors.primaryGradient.createShader(bounds),
                          child: const Text(
                            'Halo',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSizes.sm),

                        // Tagline
                        Text(
                          'Kết nối • Chia sẻ • Khám phá',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.7,
                            ),
                            letterSpacing: 2,
                          ),
                        ),

                        // Bottom progress indicator
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSizes.xl),
                          child: SizedBox(
                            width: 160,
                            height: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: _ready ? 1.0 : null,
                                backgroundColor: AppColors.surfaceLight,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
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
      },
    );
  }
}
