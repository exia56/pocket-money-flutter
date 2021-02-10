import 'dart:convert';

import 'package:logger/logger.dart';

class TagPrinter extends LogPrinter {
  final String tag;
  final JsonEncoder _jsonEncoder = JsonEncoder();
  TagPrinter(this.tag);

  static final levelPrefixes = {
    Level.verbose: '[VERBOSE]',
    Level.debug: '[DEBUG]',
    Level.info: '[INFO]',
    Level.warning: '[WARNING]',
    Level.error: '[ERROR]',
    Level.wtf: '[WTF]',
  };

  @override
  List<String> log(LogEvent event) {
    var result =
        '[${levelPrefixes[event.level]}] [$tag] msg=${_stringifyMessage(event.message)}\n';

    if (event.error != null) {
      result += ' error=${event.error.toString().replaceAll('\\', '\\\\')}\n';
    }
    if (event.stackTrace != null) {
      result +=
          ' stack=${event.stackTrace.toString().replaceAll('\\', '\\\\')}';
    }
    return [result];
  }

  String _stringifyMessage(dynamic message) {
    if (message is Map) {
      return _jsonEncoder.convert(message);
    }
    return message.toString();
  }
}

Logger createLogger(String tag) {
  return Logger(printer: TagPrinter(tag));
}
