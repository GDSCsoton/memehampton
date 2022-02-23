import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'url': url,
      'createdAt': Timestamp.fromDate(createdAt),
      'votes': votes,
      'caption': caption,
    };
  }

  factory Meme.fromMap(Map<String, dynamic> map) {
    return Meme(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      url: map['url'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      votes: map['votes']?.toInt() ?? 0,
      caption: map['caption'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Meme.fromJson(String source) => Meme.fromMap(json.decode(source));
}

enum MemeFilter { latest, popular }
