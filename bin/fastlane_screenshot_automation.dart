import 'dart:io';

import 'package:fastlane_screenshot_automation/args_parser.dart';
import 'package:fastlane_screenshot_automation/ruby/ruby.dart';

void main(List<String> args) async {
  final parser = getParser(args);

  Ruby.checkIfInstalled();
}
