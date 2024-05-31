import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'chat_response.dart';

class StreamingPage extends StatefulWidget {
  const StreamingPage({super.key});

  @override
  _StreamingPageState createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text;
    _controller.clear();

    if (text.isNotEmpty) {
      setState(() {
        _messages.add('You: $text');
        _messages.add('Bot: '); // Placeholder for bot response
      });

      var response = '';
      getChatResponse(text).listen((word) {
        setState(() {
          response += word;
          _messages[_messages.length - 1] = 'Bot: $response';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Bot'),
      ),
      body: Column(
        children: [
          _buildMessages(),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return Expanded(
      child: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          // Ensure new lines are correctly interpreted
          String message = _messages[index].replaceAll('\\n', '\n');
          return ListTile(
            title: MarkdownBody(
              data: message,
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                p: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type your message here...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
