import 'package:flutter/material.dart';

class NewMemPage extends StatelessWidget {
  static const String path = '/new-meme';
  const NewMemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Meme')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(border: Border.all(style: BorderStyle.solid)),
            ),
          ),
        ],
      ),
    );
  }
}
