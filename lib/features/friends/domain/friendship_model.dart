import 'package:freezed_annotation/freezed_annotation.dart';

part 'friendship_model.freezed.dart';
part 'friendship_model.g.dart';

@freezed
abstract class FriendshipModel with _$FriendshipModel {
  const factory FriendshipModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'friend_id') required String friendId,
    @Default('pending') String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Joined profile data
    @JsonKey(name: 'friend_profile') Map<String, dynamic>? friendProfile,
  }) = _FriendshipModel;

  factory FriendshipModel.fromJson(Map<String, dynamic> json) =>
      _$FriendshipModelFromJson(json);
}
