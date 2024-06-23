import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Stream<String> getChatResponse(String content) async* {
  final url =
      'https://gdsc-upn-jatim-ml-muf7kziviq-as.a.run.app/generate_text_stream';
  final headers = {
    'Content-Type': 'application/json',
  };
  final body = json.encode({'prompt': content});

  var request = http.Request('POST', Uri.parse(url))
    ..headers.addAll(headers)
    ..body = body;

  var streamedResponse = await request.send();

  await for (var line in streamedResponse.stream
      .transform(utf8.decoder)) {
    for (var word in line.split('')) {
      await Future.delayed(Duration(milliseconds: 10));
      yield word + '';
    }
  }
}
