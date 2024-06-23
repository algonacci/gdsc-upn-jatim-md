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
  String _currentStream = '';

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
        _currentStream = '$_currentStream${word.text}';
        // print('_currentStream $_currentStream');
        setState(() {
          // response += word;
          _messages[_messages.length-1] = 'Bot: $_currentStream';
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
        String message = _messages[index];
        bool isUserMessage = message.startsWith('You: ');
        
        
        if (isUserMessage) {
          return ListTile(
            title: Text(message),
          );
        } else {
          // Remove the 'Bot: ' prefix for markdown rendering
          // message = message.replaceFirst('Bot: ', '');
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MarkdownBody(
              data: message,
              styleSheet: MarkdownStyleSheet(
                // p: TextStyle(fontSize: 16, height: 1.5),
                // strong: TextStyle(fontWeight: FontWeight.bold),
                // listBullet: TextStyle(fontSize: 16),
                // blockSpacing: 8,
                // listIndent: 20,
                // listBulletPadding: EdgeInsets.only(right: 8),
              ),
              // builders: {
              //   'p': (_, child) => Padding(
              //     padding: EdgeInsets.only(bottom: 8),
              //     child: child,
              //   ),
              // },
            ),
          );
        }
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
