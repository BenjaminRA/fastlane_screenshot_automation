import 'dart:io';

import 'package:fastlane_screenshot_automation/getDirectories.dart';

class Ruby {
  static void checkIfInstalled() {
    try {
      Process.runSync('ruby', ['-v'], runInShell: true);
    } catch (e) {
      print('Ruby is not installed, please install Ruby before running the script');
      exit(0);
    }
  }

  static void initBundler() {
    try {
      Process.runSync('gem', ['install', 'bundler'], runInShell: true);
    } catch (e) {
      print('It is not recommended to install bundler as sudo. Please modify the gem installation folder');
      print("You can use the following commands:\n\nexport GEM_HOME=~/.gem\nexport PATH=\"\$GEM_HOME/bin:\$PATH\"\n");
      exit(0);
    }

    final directories = getDirectories();
    for (String dir in directories) {
      File('$dir/Gemfile')
        ..createSync(recursive: true)
        ..writeAsStringSync("source \"https://rubygems.org\"\n\ngem \"fastlane\"");

      Process.runSync('bundle', ['update'], workingDirectory: dir, runInShell: true);
    }
  }
}
