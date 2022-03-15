import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memehampton/firebase_options.dart';
import 'package:memehampton/pages/home_page.dart';
import 'package:memehampton/pages/sign_in_page.dart';
import 'package:memehampton/pages/new_meme_page.dart';

/// The entrypoint of the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Connects to our Firebase Project.
  await Firebase.initializeApp(options: _decodedFirebaseOptions());
  // Wait until Firebase Auth is aware of a user.
  await FirebaseAuth.instance.authStateChanges().first;
  // Removes the # symbol from the url.
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
  // Hides the splash screen and runs the app.
  runApp(MemehamptonApp());
}

FirebaseOptions _decodedFirebaseOptions() {
  final map = DefaultFirebaseOptions.currentPlatform.asMap;
  for (var entry in map.entries.where((e) => e.value != null)) {
    map[entry.key] = utf8.fuse(base64).decode(map[entry.key]!);
  }
  return FirebaseOptions.fromMap(map);
}

class MemehamptonApp extends StatelessWidget {
  /// Routes the app can navigate to.
  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: HomePage.path,
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: SignInPage.path,
        builder: (context, state) => SignInPage(),
      ),
      GoRoute(
        path: NewMemePage.path,
        builder: (context, state) => NewMemePage(),
      ),
    ],
    initialLocation: signedIn() ? HomePage.path : SignInPage.path,
  );

  /// True if the user is signed in.
  bool signedIn() => FirebaseAuth.instance.currentUser != null;

  @override
  Widget build(BuildContext context) {
    final FlexColorScheme colorScheme = FlexColorScheme.light(
      scheme: FlexScheme.blueWhale,
      fontFamily: GoogleFonts.poppins().fontFamily,
    );

    return MaterialApp.router(
      title: 'Memehampton',
      theme: colorScheme.toTheme,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}
