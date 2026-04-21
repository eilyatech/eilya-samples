import 'package:flutter/material.dart';
import 'package:eilya_otp/eilya_otp.dart';
import 'package:eilya_chat/eilya_chat.dart';

void main() {
  // Initialize Eilya SDKs
  EilyaOtp.init(apiKey: 'ek_test_your_api_key_here'); // Replace with your API key
  EilyaChat.init(apiKey: 'ec_test_your_api_key_here'); // Replace with your API key

  runApp(const EilyaSampleApp());
}

class EilyaSampleApp extends StatelessWidget {
  const EilyaSampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eilya SDK Sample',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF7C3AED),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // OTP state
  final _phoneController = TextEditingController();
  final _otpCodeController = TextEditingController();
  String? _pipelineId;
  String _otpStatus = '';
  bool _showVerify = false;

  // Chat state
  final _chatController = TextEditingController();
  String _chatStatus = '';

  // ── OTP: Request ───────────────────────────────────────────────

  Future<void> _requestOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() => _otpStatus = 'Enter a phone number');
      return;
    }

    setState(() => _otpStatus = 'Sending OTP...');

    try {
      final pipeline = await EilyaOtp.requestOtp(phone: phone);
      setState(() {
        _pipelineId = pipeline.pipelineId;
        _otpStatus = 'OTP sent via ${pipeline.channelUsed}\nPipeline: ${pipeline.pipelineId}';
        _showVerify = true;
      });
    } catch (e) {
      setState(() => _otpStatus = 'Error: $e');
    }
  }

  // ── OTP: Verify ────────────────────────────────────────────────

  Future<void> _verifyOtp() async {
    final code = _otpCodeController.text.trim();
    if (code.isEmpty || _pipelineId == null) {
      setState(() => _otpStatus = 'Enter the OTP code');
      return;
    }

    setState(() => _otpStatus = 'Verifying...');

    try {
      final result = await EilyaOtp.verifyOtp(
        pipelineId: _pipelineId!,
        code: code,
      );
      setState(() {
        _otpStatus = 'Verified!\nToken: ${result.authToken}\nPhone: ${result.phone}';
      });
    } catch (e) {
      setState(() => _otpStatus = 'Failed: $e');
    }
  }

  // ── Chat: Send ─────────────────────────────────────────────────

  Future<void> _sendChat() async {
    final message = _chatController.text.trim();
    if (message.isEmpty) {
      setState(() => _chatStatus = 'Enter a message');
      return;
    }

    _chatController.clear();
    setState(() => _chatStatus = 'Sending...');

    try {
      final reply = await EilyaChat.sendMessage(content: message);
      setState(() => _chatStatus = 'You: $message\n\nBot: ${reply.content}');
    } catch (e) {
      setState(() => _chatStatus = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eilya SDK Sample')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── OTP Section ──────────────────────────────────
            Text('OTP Verification',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple)),
            const SizedBox(height: 12),

            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                hintText: '+201012345678',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _requestOtp,
                style: FilledButton.styleFrom(backgroundColor: Colors.purple),
                child: const Text('Request OTP'),
              ),
            ),
            const SizedBox(height: 8),

            if (_showVerify) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _otpCodeController,
                      decoration: const InputDecoration(
                        labelText: 'OTP Code',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _verifyOtp,
                    style: FilledButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Verify'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            if (_otpStatus.isNotEmpty)
              Text(_otpStatus, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontFamily: 'monospace')),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            // ── Chat Section ─────────────────────────────────
            Text('AI Chat',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _sendChat,
                  style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Send'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (_chatStatus.isNotEmpty)
              Text(_chatStatus, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontFamily: 'monospace')),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpCodeController.dispose();
    _chatController.dispose();
    super.dispose();
  }
}
