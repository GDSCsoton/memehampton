import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents the contents of a meme.
class Meme {
  Meme({
    required this.userId,
    required this.imageUrl,
    required this.createdAt,
    required this.votes,
    required this.id,
    required this.caption,
  });

  /// A globally unique identifier.
  final String id;

  /// The identifier of the user uploading the meme.
  final String userId;

  /// The URL of the image associated with the meme.
  final String imageUrl;

  /// The date that the meme was created at.
  final DateTime createdAt;

  /// The number of votes the meme has.
  final int votes;

  /// The message the meme was captioned with.
  /// Useful for screen readers.
  final String caption;

  /// Converts this [Meme] into a format compatible with a
  /// Firebase Firestore document.
  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'uid': userId,
      'url': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'votes': votes,
      'caption': caption,
    };
  }

  /// Creates a new [Meme] from the data of a Firebase Firestore document.
  factory Meme.fromDocument(Map<String, dynamic> map) {
    return Meme(
      id: map['id'] ?? '',
      userId: map['uid'] ?? '',
      imageUrl: map['url'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      votes: map['votes']?.toInt() ?? 0,
      caption: map['caption'] ?? '',
    );
  }
}

/// Specifies how a list of memes should be ordered.
enum MemeFilter {
  /// New memes first.
  latest,

  /// Memes with the most votes first.
  popular
}
