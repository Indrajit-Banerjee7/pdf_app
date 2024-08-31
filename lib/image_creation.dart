import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// void main() {
//   runApp(NameToImageApp());
// }

class NameToImageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name to Image',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NameInputScreen(),
    );
  }
}

class NameInputScreen extends StatefulWidget {
  @override
  _NameInputScreenState createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final _nameController = TextEditingController();
  String? _imagePath;

  Future<void> _generateImage(String name) async {
    // Create an empty image with a white background
    final image = img.Image(width: 800, height: 800);
    //img.fill(image, color: img.ColorFloat16.rgb(222, 2, 2));
    //img.fill(image, img.getColor(255, 255, 255), color: null); // Fill with white color

    // Draw the text on the image
    img.drawString(image, name, font:img.arial48);

    // Get the temporary directory and save the image
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/name.png");

    // Save the image as PNG
    await file.writeAsBytes(img.encodePng(image));

    setState(() {
      _imagePath = file.path;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Image Generated!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name to Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  _generateImage(_nameController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a name")),
                  );
                }
              },
              child: Text('Generate Image'),
            ),
            SizedBox(height: 20),
            if (_imagePath != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewScreen(imagePath: _imagePath!),
                    ),
                  );
                },
                child: Text('View Image'),
              ),
          ],
        ),
      ),
    );
  }
}

class ImageViewScreen extends StatelessWidget {
  final String imagePath;

  ImageViewScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Image'),
      ),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
