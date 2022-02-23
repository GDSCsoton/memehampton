import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memehampton/models/meme.dart';

class Database {
  static final CollectionReference<Meme> _memesCollection = FirebaseFirestore //
      .instance
      .collection('memes')
      .withConverter<Meme>(
        fromFirestore: (snapshot, _) => Meme.fromDocument(snapshot.data()!),
        toFirestore: (meme, _) => meme.toDocument(),
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
  static Future<void> downvoteMeme(Meme meme) => _updateVote(meme: meme, upvote: false);

  static Future<void> _updateVote({
    required Meme meme,
    required bool upvote,
  }) {
    return _memesCollection //
        .doc(meme.id)
        .update({'votes': FieldValue.increment(upvote ? 1 : -1)});
  }

  static Future<void> createMeme({
    required String imageUrl,
    required String imageCaption,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    DocumentReference<Meme> doc = _memesCollection.doc();

    Meme meme = Meme(
      id: doc.id,
      uid: auth.currentUser!.uid,
      url: imageUrl,
      createdAt: DateTime.now(),
      votes: 0,
      caption: imageCaption,
    );

    await doc.set(meme);
  }

  static Future<void> deleteMeme(Meme meme) async {
    await _memesCollection.doc(meme.id).delete();
  }
}
