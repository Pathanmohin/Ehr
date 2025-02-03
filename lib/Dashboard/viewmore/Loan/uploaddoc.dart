import 'dart:convert';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class FileUploadPage extends StatefulWidget {
  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  File? _file;
  final ImagePicker _picker = ImagePicker();

  // Pick a file from the gallery or camera
  Future<void> _pickFile() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });
    }
  }

  // Upload the file via a POST API call using multipart/form-data
  Future<void> _uploadFile() async {
    if (_file == null) return;

    final String baseUrl = 'https://demo.kugelblitz.xyz:8443/fineract-provider/api/v1/client_identifiers/289/documents';  // Replace with your API endpoint
    final url = Uri.parse('$baseUrl');

    // Prepare multipart form data
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(_file!.path, filename: 'adhar back.jpg'),
      'name': 'adhar back.jpg',
      'tag': '',
      'description': '',
      'isKyc': 'true',
      'kycDocumentNumber':'993721612622', // Replace with correct value
    });

    // Prepare headers
    final headers = {
      'Fineract-Platform-TenantId': 'default',
      'Authorization':'Basic dGVzdDoxMjM0NTY='
    };

    try {
      Dio dio = Dio();

      // Bypass SSL certificate validation
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
        client.badCertificateCallback = (cert, host, port) => true; // Bypass SSL validation
      };

      Response response = await dio.post(
        url.toString(),
        data: formData,
        options: Options(
          headers: headers,
          contentType: 'application/json;charset=UTF-8', // Specify content type as multipart/form-data
        ),
      );

      // Check the response status code
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File uploaded successfully')),
        );
      } else {
        // Handle other status codes (e.g., 500)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload file. Status Code: ${response.statusCode}')),
        );
        print('Response: ${response.data}');
      }
    } catch (e) {
      // Handle errors in the request itself
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_file != null)
              Image.file(
                _file!,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Pick File'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload File'),
            ),
          ],
        ),
      ),
    );
  }
}
