
class Comment{
  String commentId;
  String postId;
  String commentUserId;
  String comment;
  DateTime commentDateTime;

//<editor-fold desc="Data Methods">

  Comment({
    required this.commentId,
    required this.postId,
    required this.commentUserId,
    required this.comment,
    required this.commentDateTime,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Comment &&
          runtimeType == other.runtimeType &&
          commentId == other.commentId &&
          postId == other.postId &&
          commentUserId == other.commentUserId &&
          comment == other.comment &&
          commentDateTime == other.commentDateTime);

  @override
  int get hashCode =>
      commentId.hashCode ^
      postId.hashCode ^
      commentUserId.hashCode ^
      comment.hashCode ^
      commentDateTime.hashCode;

  @override
  String toString() {
    return 'Comment{' +
        ' commentId: $commentId,' +
        ' postId: $postId,' +
        ' commentUserId: $commentUserId,' +
        ' comment: $comment,' +
        ' commentDateTime: $commentDateTime,' +
        '}';
  }

  Comment copyWith({
    String? commentId,
    String? postId,
    String? commentUserId,
    String? comment,
    DateTime? commentDateTime,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      postId: postId ?? this.postId,
      commentUserId: commentUserId ?? this.commentUserId,
      comment: comment ?? this.comment,
      commentDateTime: commentDateTime ?? this.commentDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': this.commentId,
      'postId': this.postId,
      'commentUserId': this.commentUserId,
      'comment': this.comment,
      'commentDateTime': this.commentDateTime.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'] as String,
      postId: map['postId'] as String,
      commentUserId: map['commentUserId'] as String,
      comment: map['comment'] as String,
      commentDateTime: DateTime.parse(map['commentDateTime'] as String),
    );
  }

//</editor-fold>
}
