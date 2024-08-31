import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';

import 'package:pdf_app/image_creation.dart';

// void main() {
//   runApp(NameToPdfApp());
// }
void main() {
  runApp(NameToImageApp());
}

class NameToPdfApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name to PDF',
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
  String? _pdfPath;

  Future<void> _generatePdf(String name) async {
    final pdf = pw.Document();
     pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Container(
        padding: pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: PdfColors.blue, // Set the border color
            width: 5, // Set the border width
          ),
        ),
        child: pw.Center(
          child: pw.Text(
            name,
            style: pw.TextStyle(
              fontSize: 40,
              color: PdfColors.black,
            ),
          ),
        ),
      ),
    ),
  );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/name.pdf");
    await file.writeAsBytes(await pdf.save());

    setState(() {
      _pdfPath = file.path;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF Generated!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name to PDF'),
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
                  _generatePdf(_nameController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please enter a name")),
                  );
                }
              },
              child: Text('Generate PDF'),
            ),
            SizedBox(height: 20),
            if (_pdfPath != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewScreen(pdfPath: _pdfPath!),

                    ),
                  );
                },
                child: Text('View PDF'),
              ),
          ],
        ),
      ),
    );
  }
}

class PdfViewScreen extends StatelessWidget {
  final String pdfPath;

  PdfViewScreen({required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View PDF'),
      ),
      body: PDFView(
        filePath: pdfPath,
      ),
    );
  }
}
