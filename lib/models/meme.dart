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
}
