import 'package:flutter/material.dart';
import 'package:websocket_sample/package/websocket_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController messageController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    messageController.dispose();

    // closing the channel
    WebsocketService.instance.channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WEB SOCKET"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Message"),
                    floatingLabelStyle: TextStyle(color: Colors.black87),
                    labelStyle: TextStyle(color: Colors.black38)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter message";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final message = messageController.text.trim();
                    // sending message
                    WebsocketService.instance.channel.sink.add(message);
                    messageController.clear();
                    FocusScope.of(context).unfocus();
                  }
                },
                child: const Text("Send"),
              ),
              const SizedBox(
                height: 32,
              ),

              // Listening message from the web socket
              StreamBuilder(
                // Get stream from the channel
                stream: WebsocketService.instance.channel.stream,
                builder: (context, snapShot) {
                  return Text(snapShot.hasData ? "${snapShot.data}" : "");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
