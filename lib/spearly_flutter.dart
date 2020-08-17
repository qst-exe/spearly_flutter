import 'dart:async';

import 'package:flutter/services.dart';

class SpearlyFlutter {
  static const MethodChannel _channel =
      const MethodChannel('spearly_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
