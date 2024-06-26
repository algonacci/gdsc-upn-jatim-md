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
  bool _isLoading = false;

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
        _isLoading = true; // Start loading
      });

      var response = '';
      getChatResponse(text).listen((word) {
        setState(() {
          response += word;
          _messages[_messages.length - 1] = 'Bot: $response';
        });
      }).onDone(() {
        setState(() {
          _isLoading = false; // Stop loading when response is done
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
          if (_isLoading) LinearProgressIndicator(),
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
                textAlign: WrapAlignment.start,
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
