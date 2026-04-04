import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    @Default('') String displayName,
    String? avatarUrl,
    @Default('') String bio,
    @Default('😊') String statusEmoji,
    @Default('') String statusText,
    double? latitude,
    double? longitude,
    DateTime? locationUpdatedAt,
    @Default(false) bool isOnline,
    DateTime? lastSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
