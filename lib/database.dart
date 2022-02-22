import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memeampton/models/meme.dart';

class Database {
  static final CollectionReference<Meme> _memesCollection = FirebaseFirestore //
      .instance
      .collection('memes')
      .withConverter<Meme>(
        fromFirestore: (snapshot, _) => Meme.fromMap(snapshot.data()!),
        toFirestore: (meme, _) => meme.toMap(),
      );

  static Query<Meme> getMemes(MemeFilter filter) {
    switch (filter) {
      case MemeFilter.latest:
        return _memesCollection.orderBy('createdAt', descending: true);
      case MemeFilter.popular:
        return _memesCollection.orderBy('votes', descending: true);
    }
  }

  static Future<void> upvoteMeme(Meme meme) => _updateVote(meme: meme, upvote: true);
  static Future<void> downvote(Meme meme) => _updateVote(meme: meme, upvote: false);

  static Future<void> _updateVote({
    required Meme meme,
    required bool upvote,
  }) {
    return _memesCollection //
        .doc(meme.id)
        .update({'votes': FieldValue.increment(upvote ? 1 : -1)});
  }
}
