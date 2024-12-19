import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketService {
  WebsocketService._();
  static final instance = WebsocketService._();
  factory WebsocketService() => instance;

  WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );
}
