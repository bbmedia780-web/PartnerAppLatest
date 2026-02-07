class ReviewModel {
  final String id;
  final String userName;
  final String userImage;
  final int rating;
  final String reviewText;
  final String timeAgo;

  ReviewModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.reviewText,
    required this.timeAgo,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      userImage: json['userImage'] ?? '',
      rating: json['rating'] ?? 0,
      reviewText: json['reviewText'] ?? '',
      timeAgo: json['timeAgo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'userImage': userImage,
      'rating': rating,
      'reviewText': reviewText,
      'timeAgo': timeAgo,
    };
  }
}

class RatingSummary {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // rating -> count

  RatingSummary({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });
}

