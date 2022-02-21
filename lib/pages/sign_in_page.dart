import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:memeampton/pages/home_page.dart';

class SignInPage extends StatelessWidget {
  static const String path = '/sign-in';

  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providerConfigs: [EmailProviderConfiguration()],
      actions: [
        AuthStateChangeAction<SignedIn>((context, _) {
          context.go(HomePage.path);
        }),
      ],
    );
  }
}
