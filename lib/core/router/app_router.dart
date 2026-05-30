import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/map/presentation/screens/map_screen.dart';
import '../../features/friends/presentation/screens/friends_list_screen.dart';
import '../../features/friends/presentation/screens/add_friend_screen.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/chat/presentation/screens/chat_room_screen.dart';
import '../../features/status/presentation/screens/status_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/notification_screen.dart';
import '../../features/profile/presentation/screens/privacy_screen.dart';
import '../constants/app_colors.dart';

// Shell for main navigation with IndexedStack — keeps all tab screens alive
// so MapScreen is never disposed when switching to Chat, Friends, etc.
// The MapWidget and its Geolocator stream stay running in the background.
class _MainShell extends StatefulWidget {
  final List<Widget> pages;
  final int currentIndex;

  const _MainShell({required this.pages, required this.currentIndex});

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: IndexedStack(index: widget.currentIndex, children: widget.pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.bottomNav,
          border: const Border(
            top: BorderSide(color: AppColors.divider, width: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.map_outlined,
                  activeIcon: Icons.map,
                  label: 'Bản đồ',
                  isActive: widget.currentIndex == 0,
                  onTap: () => context.go('/'),
                ),
                _NavItem(
                  icon: Icons.people_outline,
                  activeIcon: Icons.people,
                  label: 'Bạn bè',
                  isActive: widget.currentIndex == 1,
                  onTap: () => context.go('/friends'),
                ),
                _NavItem(
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: 'Chat',
                  isActive: widget.currentIndex == 2,
                  onTap: () => context.go('/chat'),
                ),
                _NavItem(
                  icon: Icons.mood_outlined,
                  activeIcon: Icons.mood,
                  label: 'Trạng thái',
                  isActive: widget.currentIndex == 3,
                  onTap: () => context.go('/status'),
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Hồ sơ',
                  isActive: widget.currentIndex == 4,
                  onTap: () => context.go('/profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isActive ? activeIcon : icon,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final currentPath = state.matchedLocation;
      final publicPaths = ['/login', '/register', '/splash'];

      // Cho phép SplashScreen tự quyết định thời điểm chuyển hướng
      if (currentPath == '/splash') {
        return null;
      }

      // Not logged in: redirect to login unless already on a public page
      if (!isLoggedIn && !publicPaths.contains(currentPath)) {
        return '/login';
      }

      // Logged in and on auth pages: redirect to home
      if (isLoggedIn &&
          (currentPath == '/login' || currentPath == '/register')) {
        return '/';
      }

      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main shell routes — IndexedStack keeps all tab screens alive
      ShellRoute(
        builder: (context, state, child) {
          final index = _getNavIndex(state.matchedLocation);
          return _MainShell(
            currentIndex: index,
            pages: const [
              MapScreen(),
              FriendsListScreen(),
              ChatListScreen(),
              StatusScreen(),
              ProfileScreen(),
            ],
          );
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const MapScreen()),
          GoRoute(
            path: '/friends',
            builder: (context, state) => const FriendsListScreen(),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => const ChatListScreen(),
          ),
          GoRoute(
            path: '/status',
            builder: (context, state) => const StatusScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Full-screen routes (no bottom nav)
      GoRoute(
        path: '/add-friend',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
          context: context,
          state: state,
          child: const AddFriendScreen(),
        ),
      ),
      GoRoute(
        path: '/chat/:roomId',
        pageBuilder: (context, state) {
          final roomId = state.pathParameters['roomId']!;
          // Extract optional friendName from route extra for instant title
          final extra = state.extra as Map<String, dynamic>?;
          final friendName = extra?['friendName'] as String?;
          return _buildSlideTransitionPage(
            context: context,
            state: state,
            child: ChatRoomScreen(roomId: roomId, friendName: friendName),
          );
        },
      ),
      GoRoute(
        path: '/edit-profile',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
          context: context,
          state: state,
          child: const EditProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
          context: context,
          state: state,
          child: const NotificationScreen(),
        ),
      ),
      GoRoute(
        path: '/privacy',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
          context: context,
          state: state,
          child: const PrivacyScreen(),
        ),
      ),
    ],
  );
});

int _getNavIndex(String location) {
  if (location.startsWith('/friends')) return 1;
  if (location.startsWith('/chat')) return 2;
  if (location.startsWith('/status')) return 3;
  if (location.startsWith('/profile')) return 4;
  return 0;
}

CustomTransitionPage _buildSlideTransitionPage({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeOutQuart;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}
