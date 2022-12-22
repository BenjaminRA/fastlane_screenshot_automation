import 'dart:io';
import 'dart:isolate';

String? _packagePath;

Future<String> getPackagePath() async {
  if (_packagePath == null) {
    final uri = await Isolate.resolvePackageUri(Uri.parse('package:fastlane_screenshot_automation/'));
    _packagePath = uri!.resolve('../').toFilePath(windows: Platform.isWindows);
  }

  return _packagePath!;
}
