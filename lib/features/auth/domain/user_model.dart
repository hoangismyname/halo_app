import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    @JsonKey(name: 'display_name') @Default('') String displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @Default('') String bio,
    @JsonKey(name: 'status_emoji') @Default('😊') String statusEmoji,
    @JsonKey(name: 'status_text') @Default('') String statusText,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'location_updated_at') DateTime? locationUpdatedAt,
    @JsonKey(name: 'is_online') @Default(false) bool isOnline,
    @JsonKey(name: 'last_seen') DateTime? lastSeen,
    @JsonKey(name: 'is_location_shared') @Default(true) bool isLocationShared,
    @JsonKey(name: 'location_precision') @Default('absolute') String locationPrecision,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
