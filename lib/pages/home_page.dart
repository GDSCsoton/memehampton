import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:memeampton/database.dart';

import 'package:memeampton/models/meme.dart';
import 'package:memeampton/pages/new_meme_page.dart';
import 'package:memeampton/pages/sign_in_page.dart';

class HomePage extends StatefulWidget {
  static const path = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final _tabBarController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    super.dispose();
    _tabBarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Memeampton'),
        bottom: TabBar(
          tabs: [Tab(text: 'LATEST'), Tab(text: 'POPULAR')],
          controller: _tabBarController,
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              context.go(SignInPage.path);
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: TabBarView(
        controller: _tabBarController,
        children: [
          MemeView(filter: MemeFilter.latest),
          MemeView(filter: MemeFilter.popular),
        ],
      ),
      floatingActionButton: OpenContainer(
        transitionType: ContainerTransitionType.fade,
        closedShape: CircleBorder(),
        tappable: false,
        closedColor: theme.colorScheme.secondary,
        closedBuilder: (BuildContext context, VoidCallback action) {
          return FloatingActionButton(
            elevation: 0,
            tooltip: 'New Meme',
            onPressed: action,
            child: Icon(Icons.add),
          );
        },
        openBuilder: (BuildContext context, _) {
          return NewMemPage();
        },
      ),
    );
  }
}

class MemeView extends StatelessWidget {
  MemeView({
    Key? key,
    required this.filter,
  }) : super(key: key);

  final MemeFilter filter;

  @override
  Widget build(BuildContext context) {
    return FirestoreListView<Meme>(
      query: Database.getMemes(filter),
      padding: EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, snapshot) {
        final Meme meme = snapshot.data();
        return MemeCard(meme: meme);
      },
    );
  }
}

class MemeCard extends StatelessWidget {
  const MemeCard({
    Key? key,
    required this.meme,
  }) : super(key: key);

  final Meme meme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          clipBehavior: Clip.antiAlias,
          elevation: 8,
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  meme.url,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 16),
                  Text('${meme.votes} votes'),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () => Database.upvoteMeme(meme),
                    icon: Icon(Icons.thumb_up_rounded),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () => Database.downvoteMeme(meme),
                    icon: Icon(Icons.thumb_down_rounded),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
