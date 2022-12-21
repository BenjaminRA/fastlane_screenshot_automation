import 'dart:io';

class Ruby {
  static void checkIfInstalled() {
    try {
      Process.runSync('ruby', ['-v']);
    } catch (e) {
      print('Ruby is not installed');
      exit(0);
    }
  }
}
