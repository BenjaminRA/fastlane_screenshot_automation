import 'dart:io';

import 'package:args/args.dart';

ArgResults? _result;

ArgResults getParser([List<String>? args]) {
  assert(_result != null || args != null);

  if (_result != null) {
    return _result!;
  }

  final parser = ArgParser();

  parser.addFlag(
    'android',
    help: 'Run de script for android',
    defaultsTo: true,
  );

  parser.addFlag(
    'ios',
    help: 'Run de script for ios',
    defaultsTo: true,
  );

  parser.addFlag(
    'help',
    abbr: 'h',
    help: 'Show help information',
    defaultsTo: false,
  );

  _result = parser.parse(args!);

  if (_result!['help']) {
    print(parser.usage);
    exit(0);
  }

  return _result!;
}
