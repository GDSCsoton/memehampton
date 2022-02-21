import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memeampton/firebase_options.dart';
import 'package:memeampton/pages/home_page.dart';
import 'package:memeampton/pages/sign_in_page.dart';
import 'package:memeampton/pages/new_meme_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: _decodedFirebaseOptions());
  // Wait until Firebase Auth is aware of a user.
  await FirebaseAuth.instance.authStateChanges().first;
  // Remove the # symbol from the url
  GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
  runApp(MemeamptonApp());
}

FirebaseOptions _decodedFirebaseOptions() {
  final map = DefaultFirebaseOptions.currentPlatform.asMap.entries
      .where((entry) => entry.value != null)
      .map((entry) => MapEntry(entry.key, utf8.fuse(base64).decode(entry.value!)))
      .fold<Map<String, String>>({}, (prev, elem) => {elem.key: elem.value, ...prev});
  return FirebaseOptions.fromMap(map);
}

class MemeamptonApp extends StatelessWidget {
  MemeamptonApp({Key? key}) : super(key: key);

  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: HomePage.path,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: SignInPage.path,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: NewMemPage.path,
        builder: (context, state) => const NewMemPage(),
      ),
    ],
    initialLocation: FirebaseAuth.instance.currentUser == null ? SignInPage.path : HomePage.path,
  );

  @override
  Widget build(BuildContext context) {
    final FlexColorScheme colorScheme = FlexColorScheme.light(
      scheme: FlexScheme.blueWhale,
      fontFamily: GoogleFonts.poppins().fontFamily,
    );

    return MaterialApp.router(
      title: 'Memeampton',
      theme: colorScheme.toTheme,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}
