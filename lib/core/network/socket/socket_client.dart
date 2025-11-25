import 'dart:async';
import 'dart:developer';

import "package:socket_io_client/socket_io_client.dart" as client;
import 'package:solveit/core/network/socket/delivery_event_generics.dart';
import 'package:solveit/core/network/socket/event.dart';
import 'package:solveit/features/authentication/domain/user_token.dart';
import 'package:solveit/utils/utils/strings.dart';

/// **StreamSocket** - A generic stream wrapper for handling socket events
class StreamSocket<T> {
  final _socketResponse = StreamController<T>.broadcast();

  void addResponse(T data) => _socketResponse.sink.add(data);
  Stream<T> get responseStream => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

/// **SocketClient** - Handles WebSocket connections
class SocketClient {
  final UserTokenRepository userTokenRepository;
  final String baseUrl = appBaseUrl;
  client.Socket? _socket;
  bool _isConnected = false;

  SocketClient({required this.userTokenRepository});

  /// **Initialize socket connection**
  void init() {
    if (_socket != null) {
      log("Socket already initialized.");
      return;
    }

    final token = userTokenRepository.getToken().token;
    if (token == null) {
      log("Error: No token found. Cannot connect to socket.");
      return;
    }

    log("Initializing socket connection...");
    _socket = client.io(
      baseUrl,
      client.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'authorization': 'Bearer $token'})
          .build(),
    );

    /// **Socket event listeners**
    _socket?.onConnect((_) {
      _isConnected = true;
      log("✅ Socket connected.");
    });

    _socket?.onDisconnect((_) {
      _isConnected = false;
      log("❌ Socket disconnected. Attempting to reconnect...");
      reconnect();
    });

    _socket?.onError((error) {
      log("⚠️ Socket error: $error");
    });

    _socket?.connect();
  }

  /// **Reconnect logic**
  void reconnect() {
    if (_isConnected || _socket == null) return;
    Future.delayed(const Duration(seconds: 3), () {
      if (!_isConnected) {
        log("🔄 Reconnecting socket...");
        _socket?.connect();
      }
    });
  }

  /// **Disconnect socket**
  void disconnect() {
    log("🔌 Disconnecting socket...");
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  /// **Listen to socket events**
  StreamSocket<T> connectAndListen<T>(String event) {
    if (_socket == null) init();

    log("📡 Listening for event: $event");
    final streamSocket = StreamSocket<T>();

    _socket?.on(event, (data) {
      log("📨 Received data for event [$event]: ${data.toString()}");

      try {
        var json = Map<String, dynamic>.from(data);
        final eventResponse = EventGeneric.fromJson<T>(json);
        streamSocket.addResponse(eventResponse);
      } catch (e) {
        log("❌ Error parsing event [$event]: $e");
      }
    });

    return streamSocket;
  }

  /// **Emit socket events**
  void emit(Event event) {
    if (_socket == null) init();

    log("🚀 Emitting event: ${event.name}, Data: ${event.data()}");
    _socket?.emit(event.name, event.data());
  }
}
