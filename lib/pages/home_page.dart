import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:memehampton/database.dart';
import 'package:memehampton/models/meme.dart';
import 'package:memehampton/pages/new_meme_page.dart';
import 'package:memehampton/pages/sign_in_page.dart';

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

  void signOut() {
    FirebaseAuth.instance.signOut();
    GoRouter.of(context).go(SignInPage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memehampton'),
        bottom: TabBar(
          tabs: [Tab(text: 'LATEST'), Tab(text: 'POPULAR')],
          controller: _tabBarController,
          isScrollable: true,
        ),
        actions: [
          IconButton(
            onPressed: () => signOut(),
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: TabBarView(
        controller: _tabBarController,
        children: [
          MemeList(filter: MemeFilter.latest),
          MemeList(filter: MemeFilter.popular),
        ],
      ),
      floatingActionButton: NewMemeButton(),
    );
  }
}

class NewMemeButton extends StatelessWidget {
  const NewMemeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'New Meme',
      onPressed: () => GoRouter.of(context).push(NewMemPage.path),
      child: Icon(Icons.add),
    );
  }
}

class MemeList extends StatelessWidget {
  MemeList({
    Key? key,
    required this.filter,
  }) : super(key: key);

  final MemeFilter filter;

  @override
  Widget build(BuildContext context) {
    Size windowSize = MediaQuery.of(context).size;
    double horizontalPadding = math.max(0, ((windowSize.width - 720) / 2));

    return FirestoreListView<Meme>(
      query: Database.getMemes(filter),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: horizontalPadding),
      itemBuilder: (context, snapshot) {
        Meme meme = snapshot.data();
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
    FirebaseAuth auth = FirebaseAuth.instance;
    bool isOwner = auth.currentUser!.uid == meme.userId;

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
                  meme.imageUrl,
                  fit: BoxFit.cover,
                  semanticLabel: meme.caption,
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 16),
                  Text('${meme.votes} votes'),
                  SizedBox(width: 16),
                  IconButton(
                    onPressed: () => Database.upvoteMeme(meme),
                    icon: Icon(Icons.arrow_upward_rounded),
                    color: Colors.green,
                  ),
                  IconButton(
                    onPressed: () => Database.downvoteMeme(meme),
                    icon: Icon(Icons.arrow_downward_rounded),
                    color: Colors.red,
                  ),
                  Spacer(),
                  if (isOwner)
                    IconButton(
                      onPressed: () => Database.deleteMeme(meme),
                      icon: Icon(Icons.delete),
                      color: Colors.grey,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
