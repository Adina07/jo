class Post {
  final int id;
  final int? postId;
  final String message;
  final String createdAt;
  final int likesNumber;
  final int repliesNumber;
  final bool youLiked;

  final String userLogin;
  final String userName;
  final String? profileImage;

  Post({
    required this.id,
    this.postId,
    required this.message,
    required this.createdAt,
    required this.likesNumber,
    required this.repliesNumber,
    required this.youLiked,
    required this.userLogin,
    required this.userName,
    this.profileImage,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};

    return Post(
      id: json['id'],
      postId: json['post_id'],
      message: json['message'] ?? '',
      createdAt: json['created_at'] ?? '',
      likesNumber: json['likes_number'] ?? 0,
      repliesNumber: json['replies_number'] ?? 0,
      youLiked: json['you_liked'] ?? false,
      userLogin: user['login'] ?? '',
      userName: user['name'] ?? '',
      profileImage: user['profile_image'],
    );
  }
}
