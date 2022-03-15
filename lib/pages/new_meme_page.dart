import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memehampton/database.dart';

class NewMemePage extends StatefulWidget {
  static const String path = '/new-meme';

  @override
  State<NewMemePage> createState() => _NewMemePageState();
}

class _NewMemePageState extends State<NewMemePage> {
  Uint8List? _imageBytes;
  String _imageCaption = '';
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  /// Takes a screenshot of the [MemePreview] widget.
  Future<Uint8List> captureImage() async {
    RenderRepaintBoundary boundary =
        _repaintBoundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  /// Uploads the image represented by [imageBytes] to Firebase Cloud Storage
  /// under /memes/<imageId.png>.
  Future<String> uploadImage(Uint8List imageBytes) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String imageId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = storage.ref('memes/$imageId.png');
    await reference.putData(
      imageBytes,
      SettableMetadata(contentType: 'image/png'),
    );
    return reference.getDownloadURL();
  }

  /// Uploads a screenshot of [MemePreview] to Firebase Cloud Storage then
  /// adds them a new meme to Firebase Firestore.
  Future<void> uploadMeme() async {
    Uint8List imageBytes = await captureImage();
    String url = await uploadImage(imageBytes);
    await Database.createMeme(imageCaption: _imageCaption, imageUrl: url);
    GoRouter.of(context).pop();
  }

  void setImage(Uint8List imageBytes) {
    setState(() {
      _imageBytes = imageBytes;
    });
  }

  void setCaption(String caption) {
    setState(() {
      _imageCaption = caption;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size windowSize = MediaQuery.of(context).size;
    double horizontalPadding = math.max(16, ((windowSize.width - 720) / 2));

    return Scaffold(
      appBar: AppBar(title: Text('New Meme')),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 16,
        ),
        children: [
          MemePreview(
            imageBytes: _imageBytes,
            onImageSelected: (Uint8List image) => setImage(image),
            caption: _imageCaption,
            repaintBoundaryKey: _repaintBoundaryKey,
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(hintText: 'Caption'),
            onChanged: (String caption) => setCaption(caption),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => uploadMeme(),
            child: Text('Upload Meme'),
          )
        ],
      ),
    );
  }
}

class MemePreview extends StatelessWidget {
  MemePreview({
    required this.caption,
    required this.imageBytes,
    required this.onImageSelected,
    required this.repaintBoundaryKey,
  });

  final String caption;
  final Uint8List? imageBytes;
  final Function(Uint8List) onImageSelected;
  final GlobalKey repaintBoundaryKey;

  final ImagePicker picker = ImagePicker();

  /// Displays a file picker menu.
  Future<void> selectImage() async {
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final Uint8List bytes = await image.readAsBytes();
    onImageSelected(bytes);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => selectImage(),
          child: RepaintBoundary(
            key: repaintBoundaryKey,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // The image or a placeholder icon.
                imageBytes == null
                    ? Center(
                        child: Icon(
                          Icons.add_photo_alternate_rounded,
                          color: colorScheme.secondary,
                          size: 128,
                        ),
                      )
                    : Image.memory(imageBytes!, fit: BoxFit.cover),
                // The meme caption.
                MemeText(text: caption),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MemeText extends StatelessWidget {
  const MemeText({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.grey.shade800, offset: Offset(3, 3))],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
