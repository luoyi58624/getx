import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

///VoidCallback from logs
typedef LogWriterCallback = void Function(String text, {bool enabledLog});

/// default logger from GetX
void defaultLogWriterCallback(String value, {bool enabledLog = true}) {
  if (enabledLog && kDebugMode) developer.log(value, name: 'GETX');
}
