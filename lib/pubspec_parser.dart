import 'dart:io';

import 'package:fastlane_screenshot_automation/path.dart';
import 'package:yaml/yaml.dart';

YamlMap? _parsed;

Future<YamlMap> getPubspec({bool root = false}) async {
  if (root) {
    final file = File('${Directory.current.path}/pubspec.yaml');
    final parsed = loadYaml(file.readAsStringSync());
    return parsed;
  }

  if (_parsed == null) {
    final file = File('${Directory.current.path}/pubspec.yaml');
    _parsed = loadYaml(file.readAsStringSync())['fastlane_screenshot_automation'];
  }

  return _parsed!;
}
