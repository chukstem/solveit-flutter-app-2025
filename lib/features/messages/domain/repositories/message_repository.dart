import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:solveit/features/messages/data/model/message_model.dart';

class MessageRepository {
  final String _baseUrl = '(link unavailable)';

  Future<List<Message>> getMessages() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/messages'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData.map((message) => Message.fromJson(message)).toList();
      } else {
        throw Exception('Failed to load messages');
      }
    } on TimeoutException {
      throw Exception('Timeout: Failed to load messages');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Message>> searchMessages(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/messages?q=$query'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData.map((message) => Message.fromJson(message)).toList();
    } else {
      throw Exception('Failed to search messages');
    }
  }
}
