import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class VoiceService {
  /// Uploads an audio file to the local server for vocal separation.
  /// Returns the path to the downloaded vocals file.
  Future<String> separateVocals({
    required String serverUrl,
    required String filePath,
    required String downloadPath,
  }) async {
    final uri = Uri.parse('$serverUrl/separate');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final file = File(downloadPath);
      await file.writeAsBytes(response.bodyBytes);
      return downloadPath;
    } else {
      throw Exception('Server error: ${response.statusCode} - ${response.body}');
    }
  }

  /// Checks if the voice server is online.
  Future<bool> checkStatus(String serverUrl) async {
    try {
      final res = await http.get(Uri.parse('$serverUrl/status')).timeout(const Duration(seconds: 3));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
