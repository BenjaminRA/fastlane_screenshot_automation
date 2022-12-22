import 'dart:io';

import 'package:args/args.dart';
import 'package:fastlane_screenshot_automation/getDirectories.dart';
import 'package:fastlane_screenshot_automation/path.dart';
import 'package:fastlane_screenshot_automation/pubspec_parser.dart';

class Fastlane {
  static Future<void> init(ArgResults args) async {
    final directories = getDirectories();
    final pubspec = await getPubspec();
    for (String dir in directories) {
      bool isAndroid = dir.endsWith('android');

      final appFile = File('$dir/fastlane/Appfile')
        ..createSync(recursive: true)
        ..writeAsStringSync(
          (isAndroid ? File('${await getPackagePath()}/assets/android/Appfile') : File('${await getPackagePath()}/assets/ios/Appfile'))
              .readAsStringSync()
              .replaceAll('path/to/json_key_file', pubspec['android_json_key_file_path'])
              .replaceAll('com.example.app', pubspec['android_package_name']),
        );

      final fastFile = File('$dir/fastlane/Fastfile')
        ..createSync(recursive: true)
        ..writeAsStringSync(
          (isAndroid ? File('${await getPackagePath()}/assets/android/Fastfile') : File('${await getPackagePath()}/assets/ios/Fastfile'))
              .readAsStringSync()
              .replaceAll('track: \'beta\',', pubspec['android_beta_track']),
        );
    }
  }
}
