import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:memehampton/pages/home_page.dart';

class SignInPage extends StatelessWidget {
  static const String path = '/sign-in';

  @override
  Widget build(BuildContext context) {
    // A prebuilt sign in screen provided by the flutterfire_ui package.
    return SignInScreen(
      // The allowed sign in methods. Google/Apple/Facebook/... auth could
      // be added in the future.
      providerConfigs: [EmailProviderConfiguration()],
      actions: [
        AuthStateChangeAction<SignedIn>((context, _) {
          // Navigate to the home page once the user signs in.
          GoRouter.of(context).go(HomePage.path);
        }),
      ],
    );
  }
}
