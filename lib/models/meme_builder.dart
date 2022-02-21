import 'package:memeampton/models/meme.dart';

class MemeBuilder {
  String? id;
  String? uid;
  String? url;
  DateTime? createdAt;
  int? votes;

  Meme build() {
    return Meme(
      id: ArgumentError.checkNotNull(id, 'id'),
      uid: ArgumentError.checkNotNull(uid, 'uid'),
      url: ArgumentError.checkNotNull(url, 'url'),
      createdAt: ArgumentError.checkNotNull(createdAt, 'createdAt'),
      votes: ArgumentError.checkNotNull(votes, 'votes'),
    );
  }
}
