import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memehampton/database.dart';

class NewMemPage extends StatefulWidget {
  static const String path = '/new-meme';
  const NewMemPage({Key? key}) : super(key: key);

  @override
  State<NewMemPage> createState() => _NewMemPageState();
}

class _NewMemPageState extends State<NewMemPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Uint8List? _imageBytes;
  String _imageCaption = '';
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  Future<Uint8List> captureImage() async {
    RenderRepaintBoundary boundary =
        _repaintBoundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<String> uploadImage(Uint8List imageBytes) async {
    String imageId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = storage.ref('memes/$imageId.png');
    await reference.putData(
      imageBytes,
      SettableMetadata(contentType: 'image/png'),
    );
    return reference.getDownloadURL();
  }

  Future<void> uploadMeme() async {
    Uint8List imageBytes = await captureImage();

    String url = await uploadImage(imageBytes);

    await Database.createMeme(imageCaption: _imageCaption, imageUrl: url);

    Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(title: Text('New Meme')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          MemePreview(
            imageBytes: _imageBytes,
            onImageSelected: (image) => setImage(image),
            caption: _imageCaption,
            repaintBoundaryKey: _repaintBoundaryKey,
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(hintText: 'Caption'),
            onChanged: (caption) => setCaption(caption),
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
    Key? key,
    required this.caption,
    required this.imageBytes,
    required this.onImageSelected,
    required this.repaintBoundaryKey,
  }) : super(key: key);

  final String caption;
  final Uint8List? imageBytes;
  final Function(Uint8List) onImageSelected;
  final GlobalKey repaintBoundaryKey;

  final ImagePicker picker = ImagePicker();

  Future<void> selectImage() async {
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final Uint8List bytes = await image.readAsBytes();
    onImageSelected(bytes);
  }

  @override
  Widget build(BuildContext context) {
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
                imageBytes == null
                    ? Center(child: Icon(Icons.image))
                    : Image.memory(imageBytes!, fit: BoxFit.cover),
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
  const MemeText({Key? key, required this.text}) : super(key: key);
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
      ),
    );
  }
}
