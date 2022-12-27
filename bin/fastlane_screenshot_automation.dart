import 'dart:io';
import 'dart:isolate';

import 'package:fastlane_screenshot_automation/args_parser.dart';
import 'package:fastlane_screenshot_automation/fastlane.dart';
import 'package:fastlane_screenshot_automation/getDirectories.dart';
import 'package:fastlane_screenshot_automation/path.dart';
import 'package:fastlane_screenshot_automation/pubspec_parser.dart';
import 'package:fastlane_screenshot_automation/ruby.dart';

void main(List<String> args) async {
  final parser = getParser(args);

  await checkVariables();

  Ruby.checkIfInstalled();

  Ruby.initBundler();

  await Fastlane.init(parser);

  final pwd = Directory.current.path;
  final packagePath = await getPackagePath();
  final pubspec = await getPubspec();
  final pubspecRoot = await getPubspec(root: true);

  // Copying test files
  File('$pwd/integration_test/screenshot_test.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(
        File('$packagePath/assets/screenshot_test.dart').readAsStringSync().replaceAll('package:PACKAGE_NAME', 'package:${pubspecRoot['name']}'));

  File('$pwd/test_driver/screenshot_integration_test_driver.dart')
    ..createSync(recursive: true)
    ..writeAsStringSync(File('$packagePath/assets/screenshot_integration_test_driver.dart').readAsStringSync());

  // Copying android start script
  File('$pwd/android/start_tests.sh')
    ..createSync(recursive: true)
    ..writeAsStringSync(File('$packagePath/assets/android/start_tests.sh').readAsStringSync());

  File('$pwd/android.dockerfile')
    ..createSync(recursive: true)
    ..writeAsStringSync(
      File('$packagePath/assets/android/android.dockerfile').readAsStringSync().replaceAll('SUPPLIED_FLUTTER_VERSION', pubspec['flutter_version']),
    );

  // Copying ios ci_scripts
  File('$pwd/ios/ci_scripts/ci_post_clone.sh')
    ..createSync(recursive: true)
    ..writeAsStringSync(
      File('$packagePath/assets/ios/ci_scripts/ci_post_clone.sh')
          .readAsStringSync()
          .replaceAll('SUPPLIED_FLUTTER_VERSION', pubspec['flutter_version']),
    );

  File('$pwd/ios/ci_scripts/ci_post_xcodebuild.sh')
    ..createSync(recursive: true)
    ..writeAsStringSync(File('$packagePath/assets/ios/ci_scripts/ci_post_xcodebuild.sh').readAsStringSync());

  // Bringin metadata
  for (String dir in getDirectories()) {
    bool isAndroid = dir.endsWith('android');

    if (isAndroid) {
      Process.runSync('bundle', ['exec', 'fastlane', 'supply', 'init'], workingDirectory: dir, runInShell: true);
    } else {
      Process.runSync('bundle', ['exec', 'fastlane', 'deliver_init'], workingDirectory: dir, runInShell: true);
    }
  }
}

Future<void> checkVariables() async {
  final pubspec = await getPubspec();
  final parser = getParser();

  if (parser['ios']) {
    if (Platform.environment['API_KEY_ID'] == null) {
      print('The variable API_KEY_ID needs to be set with the key_id associated with your app_store_connect_api_key');
      exit(0);
    }

    if (Platform.environment['API_ISSUER_ID'] == null) {
      print('The variable API_ISSUER_ID needs to be set with the issuer_id associated with your app_store_connect_api_key');
      exit(0);
    }

    if (Platform.environment['API_KEY_CONTENT'] == null) {
      print('The variable API_KEY_CONTENT needs to be set with the key_content with base64 encoding associated with your app_store_connect_api_key');
      exit(0);
    }

    if (pubspec['ios_package_name'] == null) {
      print('The variable ios_package_name needs to be set in your pubspec.yaml under fastlane_screenshot_automation');
      exit(0);
    }
  }

  if (pubspec['flutter_version'] == null) {
    print('The variable flutter_version needs to be set in your pubspec.yaml under fastlane_screenshot_automation');
    exit(0);
  }

  if (parser['android']) {
    if (pubspec['android_beta_track'] == null) {
      print('The variable android_beta_track needs to be set in your pubspec.yaml under fastlane_screenshot_automation');
      exit(0);
    }

    if (pubspec['android_package_name'] == null) {
      print('The variable android_package_name needs to be set in your pubspec.yaml under fastlane_screenshot_automation');
      exit(0);
    }

    if (pubspec['android_json_key_file_path'] == null) {
      print('The variable android_json_key_file_path needs to be set in your pubspec.yaml under fastlane_screenshot_automation');
      exit(0);
    }
  }
}
