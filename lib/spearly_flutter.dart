library spearly_flutter;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

const String _html = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>Title</title>
  <meta name="description" content="" />
  <meta name="keywords" content="" />
  <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=0">
</head>
<body>
<div data-role="page" data-title="Sample1">
  <div data-role="header">
  </div>
  <div data-role="content">
    <spearly-content>
      <h1>{%title%}</h1>
      <img src="{%image%}" />
      <p>{%description%}</p>
      {%body%}
    </spearly-content>
  </div>
  <div data-role="footer">
  </div>
</div>
</body>
</html>
''';

class SpearlyFlutter extends StatefulWidget {
  final String apiKey;
  final String contentId;
  final double width;
  final double height;
  final bool disableTitle;
  final bool disableImage;
  final bool disableDescription;
  final bool disableBody;

  SpearlyFlutter({
    @required this.apiKey,
    @required this.contentId,
    this.width,
    this.height,
    this.disableTitle = false,
    this.disableImage = false,
    this.disableDescription = false,
    this.disableBody = false,
  });

  @override
  _SpearlyFlutterState createState() => _SpearlyFlutterState();
}

class _SpearlyFlutterState extends State<SpearlyFlutter> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    double _contentWidth = (widget.width != null) ? widget.width : _screenWidth;
    double _contentHeight =
        (widget.height != null) ? widget.height : _screenHeight;

    return FutureBuilder(
      future: _getContent(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
        if (snap.hasData && !snap.hasError) {
          final fields = snap.data["fields"];
          final String _title =
              (fields["title"] != null) ? fields["title"]["value"] : "";
          final String _image =
              (fields["image"] != null) ? fields["image"]["value"] : "";
          final String _body =
              (fields["body"] != null) ? fields["body"]["value"] : "";
          final String _description = (fields["description"] != null)
              ? fields["description"]["value"]
              : "";
          return Container(
              width: _contentWidth,
              height: _contentHeight,
              child: WebView(
                onWebViewCreated: (WebViewController webViewController) async {
                  _controller = webViewController;
                  await _loadHtmlFromAssets(
                      title: _title,
                      image: _image,
                      description: _description,
                      body: _body);
                },
                javascriptMode: JavascriptMode.unrestricted,
              ));
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Future _loadHtmlFromAssets(
      {String title, String image, String description, String body}) async {
    String _htmlText = _html;
    // タイトルの置換
    if (widget.disableTitle == false) {
      _htmlText = _htmlText.replaceAll('{%title%}', title);
    } else {
      _htmlText = _htmlText.replaceAll('''<h1>{%title%}</h1>''', "");
    }
    // メイン画像の置換
    if (widget.disableImage == false) {
      _htmlText = _htmlText.replaceAll('{%image%}', image);
    }
    // 説明文の置換
    if (widget.disableDescription == false) {
      _htmlText = _htmlText.replaceAll('{%description%}', description);
    } else {
      _htmlText = _htmlText.replaceAll('''<p>{%description%}</p>''', "");
    }
    // bodyの置換
    if (widget.disableBody == false) {
      _htmlText = _htmlText.replaceAll('{%body%}', body);
    } else {
      _htmlText = _htmlText.replaceAll('{%body%}', "");
    }
    await _controller.loadUrl(Uri.dataFromString(_htmlText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  _getContent() async {
    final http.Response response = await http.get(
      "https://www.spearly.com/api/v1/contents/${widget.contentId}",
      headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.apiKey}"},
    );
    if (response.statusCode != 200) {
      return;
    }

    return json.decode(response.body);
  }
}
