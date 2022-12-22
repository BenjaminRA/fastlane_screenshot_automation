import 'dart:io';

import 'package:fastlane_screenshot_automation/args_parser.dart';

List<String>? _result;
List<String> getDirectories() {
  if (_result == null) {
    final parser = getParser();
    _result = <String>[];
    if (parser['android']) {
      _result!.add('${Directory.current.path}/android');
    }

    if (parser['ios']) {
      _result!.add('${Directory.current.path}/ios');
    }
  }

  return _result!;
}
