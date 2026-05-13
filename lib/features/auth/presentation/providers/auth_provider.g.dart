// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Watches auth state changes from Supabase.

@ProviderFor(authStateChanges)
final authStateChangesProvider = AuthStateChangesProvider._();

/// Watches auth state changes from Supabase.

final class AuthStateChangesProvider
    extends
        $FunctionalProvider<AsyncValue<AuthState>, AuthState, Stream<AuthState>>
    with $FutureModifier<AuthState>, $StreamProvider<AuthState> {
  /// Watches auth state changes from Supabase.
  AuthStateChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateChangesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateChangesHash();

  @$internal
  @override
  $StreamProviderElement<AuthState> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AuthState> create(Ref ref) {
    return authStateChanges(ref);
  }
}

String _$authStateChangesHash() => r'084fabfae7a75366baf1801faab341eba4ef1545';

/// Current authenticated Supabase user.

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// Current authenticated Supabase user.

final class CurrentUserProvider extends $FunctionalProvider<User?, User?, User?>
    with $Provider<User?> {
  /// Current authenticated Supabase user.
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  User? create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(User? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<User?>(value),
    );
  }
}

String _$currentUserHash() => r'645e80758f77ee9cf155850d553e1050dff412b0';

/// Current user's profile from the `profiles` table.

@ProviderFor(currentProfile)
final currentProfileProvider = CurrentProfileProvider._();

/// Current user's profile from the `profiles` table.

final class CurrentProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserModel?>,
          UserModel?,
          FutureOr<UserModel?>
        >
    with $FutureModifier<UserModel?>, $FutureProvider<UserModel?> {
  /// Current user's profile from the `profiles` table.
  CurrentProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentProfileHash();

  @$internal
  @override
  $FutureProviderElement<UserModel?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserModel?> create(Ref ref) {
    return currentProfile(ref);
  }
}

String _$currentProfileHash() => r'f0b6158f86acb6d00db0d210c023816588115348';

/// Auth notifier for login, signup, and logout actions.

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

/// Auth notifier for login, signup, and logout actions.
final class AuthNotifierProvider
    extends $AsyncNotifierProvider<AuthNotifier, void> {
  /// Auth notifier for login, signup, and logout actions.
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();
}

String _$authNotifierHash() => r'c976ef8defa87b622062029e71f19d52f4283490';

/// Auth notifier for login, signup, and logout actions.

abstract class _$AuthNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Whether the user is currently authenticated with Supabase.

@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = IsAuthenticatedProvider._();

/// Whether the user is currently authenticated with Supabase.

final class IsAuthenticatedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether the user is currently authenticated with Supabase.
  IsAuthenticatedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isAuthenticatedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isAuthenticatedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isAuthenticated(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isAuthenticatedHash() => r'54fa2e7165f29e09a4d03d1f0bf7ae0df72cf5dc';
