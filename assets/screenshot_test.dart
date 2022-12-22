import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:PACKAGE_NAME/main.dart';

Future<void> waitFor(WidgetTester tester, Finder finder) async {
  do {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 100));
  } while (finder.evaluate().isEmpty);
}

Future<void> waitForDisappearing(WidgetTester tester, Finder finder) async {
  do {
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 100));
  } while (finder.evaluate().isNotEmpty);
}

Future<void> main() async {
  final IntegrationTestWidgetsFlutterBinding binding = IntegrationTestWidgetsFlutterBinding();

  testWidgets('screenshot', (WidgetTester tester) async {
    await binding.convertFlutterSurfaceToImage();

    await tester.pumpWidget(MyApp());

    print('pumpAndSettle...');
    await tester.pumpAndSettle();
  });
}
