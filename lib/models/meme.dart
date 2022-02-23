import 'package:cloud_firestore/cloud_firestore.dart';

class Meme {
  Meme({
    required this.uid,
    required this.url,
    required this.createdAt,
    required this.votes,
    required this.id,
    required this.caption,
  });

  final String id;
  final String uid;
  final String url;
  final DateTime createdAt;
  final int votes;
  final String caption;

  Map<String, dynamic> toDocument() {
    return {
      'id': id,
      'uid': uid,
      'url': url,
      'createdAt': Timestamp.fromDate(createdAt),
      'votes': votes,
      'caption': caption,
    };
  }

  factory Meme.fromDocument(Map<String, dynamic> map) {
    return Meme(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      url: map['url'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      votes: map['votes']?.toInt() ?? 0,
      caption: map['caption'] ?? '',
    );
  }
}

enum MemeFilter { latest, popular }
