# spearly_flutter

spearly_flutter can easily introduce CMS by Spearly.

You have not to prepare the server for publish  news, if you use spearly_flutter.

Do check [Spearly](https://www.spearly.com/) for more information.

## Example

```dart
import 'package:flutter/material.dart';
import 'package:spearly_flutter/spearly_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin Spearly Flutter'),
        ),
        body: SpearlyFlutter(
          apiKey: "Bearer xxxxx",
          contentId: "c-yyyyy",
          disableImage: true,
        ),
      ),
    );
  }
}

```
