// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RealtimeNotifications)
final realtimeNotificationsProvider = RealtimeNotificationsProvider._();

final class RealtimeNotificationsProvider
    extends $NotifierProvider<RealtimeNotifications, void> {
  RealtimeNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'realtimeNotificationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$realtimeNotificationsHash();

  @$internal
  @override
  RealtimeNotifications create() => RealtimeNotifications();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$realtimeNotificationsHash() =>
    r'dfa6e8091fe1eaaa451b1d6cbc613afb4f72b106';

abstract class _$RealtimeNotifications extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
