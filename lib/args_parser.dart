import 'dart:io';

import 'package:args/args.dart';

ArgResults? _result;

ArgResults getParser(List<String> args) {
  if (_result != null) {
    return _result!;
  }

  final parser = ArgParser();

  parser.addFlag(
    'help',
    abbr: 'h',
    help: 'Show help information',
    defaultsTo: false,
  );

  _result = parser.parse(args);

  if (_result!['help']) {
    print(parser.usage);
    exit(0);
  }

  return _result!;
}
