import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ssyok_finance/features/chat/domain/chat_message.dart';

/// Repository for chat operations with backend Gemini endpoint
class ChatRepository {
  final http.Client _client;
  final String _baseUrl;

  ChatRepository({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl =
          baseUrl ??
          const String.fromEnvironment(
            'BACKEND_URL',
            // demo-no-project matches the Firebase emulator's auto-detected project ID
            defaultValue:
                'http://localhost:5001/demo-no-project/asia-southeast1',
          );

  /// Stream chat response chunks from the backend SSE endpoint.
  ///
  /// Emits each text [chunk] as the model generates it.
  /// The stream completes when the server sends the `[DONE]` sentinel.
  Stream<String> streamMessage({
    required String userId,
    required List<ChatMessage> messages,
    required Map<String, dynamic> userData,
  }) async* {
    final url = Uri.parse('$_baseUrl/chat');
    final request = http.Request('POST', url)
      ..headers['Content-Type'] = 'application/json'
      ..body = jsonEncode({
        'userId': userId,
        'messages': messages.map((m) => m.toJson()).toList(),
        'userData': userData,
      });

    final http.StreamedResponse response;
    try {
      response = await _client.send(request);
    } catch (e) {
      throw ChatException('Failed to connect to backend', e.toString());
    }

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      throw ChatException('Backend error: ${response.statusCode}', body);
    }

    // Parse SSE stream: each event is `data: <json>\n\n`
    final lineStream = response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in lineStream) {
      if (!line.startsWith('data: ')) continue;

      final payload = line.substring(6).trim(); // strip 'data: '

      if (payload == '[DONE]') return;

      try {
        final Map<String, dynamic> json = jsonDecode(payload);
        if (json.containsKey('error')) {
          throw ChatException(
            'Stream error from server',
            json['error'] as String?,
          );
        }
        final chunk = json['chunk'] as String?;
        if (chunk != null && chunk.isNotEmpty) {
          yield chunk;
        }
      } catch (e) {
        if (e is ChatException) rethrow;
        // Malformed JSON — skip silently
      }
    }
  }
}

/// Custom exception for chat errors
class ChatException implements Exception {
  final String message;
  final String? details;

  ChatException(this.message, [this.details]);

  @override
  String toString() {
    if (details != null) {
      return 'ChatException: $message\nDetails: $details';
    }
    return 'ChatException: $message';
  }
}
