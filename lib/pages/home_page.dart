import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memeampton/pages/new_meme_page.dart';
import 'package:memeampton/pages/sign_in_page.dart';

class HomePage extends StatefulWidget {
  static const path = '/home';

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
          Center(child: Text('LATEST')),
          Center(child: Text('POPULAR')),
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
