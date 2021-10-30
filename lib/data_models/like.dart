
// LikeクラスのWrapクラス。
// その投稿に対していいねをしているかどうか？の情報をもたせている。
class LikeResult {
  final List<Like> likes;
  final bool isLikedToThisPost;

  LikeResult({
    required this.likes,
    required this.isLikedToThisPost,
  });
}

class Like {
  String likeId;
  String postId;
  String likeUserId;
  DateTime likeDateTIme;

//<editor-fold desc="Data Methods">

  Like({
    required this.likeId,
    required this.postId,
    required this.likeUserId,
    required this.likeDateTIme,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Like &&
          runtimeType == other.runtimeType &&
          likeId == other.likeId &&
          postId == other.postId &&
          likeUserId == other.likeUserId &&
          likeDateTIme == other.likeDateTIme);

  @override
  int get hashCode =>
      likeId.hashCode ^
      postId.hashCode ^
      likeUserId.hashCode ^
      likeDateTIme.hashCode;

  @override
  String toString() {
    return 'Like{' +
        ' likeId: $likeId,' +
        ' postId: $postId,' +
        ' likeUserId: $likeUserId,' +
        ' likeDateTIme: $likeDateTIme,' +
        '}';
  }

  Like copyWith({
    String? likeId,
    String? postId,
    String? likeUserId,
    DateTime? likeDateTIme,
  }) {
    return Like(
      likeId: likeId ?? this.likeId,
      postId: postId ?? this.postId,
      likeUserId: likeUserId ?? this.likeUserId,
      likeDateTIme: likeDateTIme ?? this.likeDateTIme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'likeId': this.likeId,
      'postId': this.postId,
      'likeUserId': this.likeUserId,
      'likeDateTIme': this.likeDateTIme.toIso8601String(),
    };
  }

  factory Like.fromMap(Map<String, dynamic> map) {
    return Like(
      likeId: map['likeId'] as String,
      postId: map['postId'] as String,
      likeUserId: map['likeUserId'] as String,
      likeDateTIme: DateTime.parse(map['likeDateTIme'] as String),
    );
  }

//</editor-fold>
}
