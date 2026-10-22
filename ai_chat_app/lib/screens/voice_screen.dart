import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:file_picker/file_picker.dart';
import '../services/native_service.dart';
import '../services/voice_service.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final VoiceService _voiceService = VoiceService();
  String _serverUrl = 'http://192.168.1.100:8000';
  bool _isOnline = false;
  bool _processing = false;
  String? _selectedPath;
  String? _resultPath;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final url = await NativeService.getSetting('voice_server_url');
    if (url.isNotEmpty) {
      setState(() => _serverUrl = url);
    }
    _checkServer();
  }

  Future<void> _checkServer() async {
    final online = await _voiceService.checkStatus(_serverUrl);
    if (mounted) setState(() => _isOnline = online);
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        _selectedPath = result.files.single.path;
        _resultPath = null;
        _statusMessage = null;
      });
    }
  }

  Future<void> _process() async {
    if (_selectedPath == null) return;
    setState(() {
      _processing = true;
      _statusMessage = 'در حال ارسال به سرور پایتون...';
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = _selectedPath!.split('/').last.split('.').first;
      final outPath = '${dir.path}/${fileName}_vocals.wav';

      final res = await _voiceService.separateVocals(
        serverUrl: _serverUrl,
        filePath: _selectedPath!,
        downloadPath: outPath,
      );

      setState(() {
        _resultPath = res;
        _statusMessage = 'جداسازی با موفقیت انجام شد ✓';
      });
    } catch (e) {
      setState(() => _statusMessage = 'خطا: $e');
    } finally {
      setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('هوش مصنوعی صوتی')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildServerStatus(),
            const SizedBox(height: 30),
            if (_selectedPath != null) ...[
              Text('فایل انتخاب شده:', style: Theme.of(context).textTheme.labelLarge),
              Text(_selectedPath!.split('/').last),
              const SizedBox(height: 10),
            ],
            ElevatedButton.icon(
              onPressed: _processing ? null : _pickFile,
              icon: const Icon(Icons.audio_file),
              label: const Text('انتخاب فایل صوتی'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (_selectedPath != null && _isOnline && !_processing) ? _process : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade100,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: _processing 
                ? const CircularProgressIndicator()
                : const Text('جداسازی صدای خواننده (Vocal Separation)'),
            ),
            const SizedBox(height: 20),
            if (_statusMessage != null)
              Text(_statusMessage!, textAlign: TextAlign.center, style: TextStyle(
                color: _statusMessage!.contains('خطا') ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              )),
            if (_resultPath != null) ...[
              const Divider(height: 40),
              const Text('خروجی آماده است:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_resultPath!),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Play audio
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('پخش صدای جدا شده'),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildServerStatus() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _isOnline ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _isOnline ? Colors.green : Colors.red),
      ),
      child: Row(
        children: [
          Icon(_isOnline ? Icons.check_circle : Icons.error, color: _isOnline ? Colors.green : Colors.red),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_isOnline ? 'سرور پایتون متصل است' : 'سرور پایتون در دسترس نیست', 
                  style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(_serverUrl, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          IconButton(onPressed: _checkServer, icon: const Icon(Icons.refresh)),
        ],
      ),
    );
  }
}
