import 'dart:convert';

class Meme {
  Meme({
    required this.uid,
    required this.url,
    required this.createdAt,
    required this.votes,
    required this.id,
  });

  final String id;
  final String uid;
  final String url;
  final DateTime createdAt;
  final int votes;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'url': url,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'votes': votes,
    };
  }

  factory Meme.fromMap(Map<String, dynamic> map) {
    return Meme(
      id: map['id'] ?? '',
      uid: map['uid'] ?? '',
      url: map['url'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      votes: map['votes']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Meme.fromJson(String source) => Meme.fromMap(json.decode(source));
}

enum MemeFilter { latest, popular }
