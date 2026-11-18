// Generates phone screenshots of Assignment 2 into test/screenshots/
//
//   flutter test test/assignment2_screenshots_test.dart --update-goldens
//
// It also checks the full flow works:
// Splash (3 sec) -> Home -> Drawer -> List -> Detail -> back -> About -> Grid -> Detail.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mad/assignment_2/a2_data.dart';
import 'package:mad/assignment_2/about_screen.dart';
import 'package:mad/assignment_2/assignment2_app.dart';
import 'package:mad/assignment_2/home_screen.dart';
import 'package:mad/assignment_2/list_screen.dart';
import 'package:mad/assignment_2/splash_screen.dart';

const Key _shotKey = Key('assignment2-shot');

Directory? _findMaterialFonts() {
  final candidates = <String>[];
  final root = Platform.environment['FLUTTER_ROOT'];
  if (root != null) candidates.add(root);
  var dir = File(Platform.resolvedExecutable).parent;
  for (var i = 0; i < 8; i++) {
    candidates.add(dir.path);
    dir = dir.parent;
  }
  for (final c in candidates) {
    final d = Directory('$c/bin/cache/artifacts/material_fonts');
    if (d.existsSync()) return d;
  }
  return null;
}

Future<void> _loadFont(String family, List<File> files) async {
  final existing = files.where((f) => f.existsSync()).toList();
  if (existing.isEmpty) return;
  final loader = FontLoader(family);
  for (final f in existing) {
    final Uint8List bytes = f.readAsBytesSync();
    loader.addFont(Future<ByteData>.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

/// Real fonts so the screenshots don't show the grey test boxes
Future<void> _loadFonts() async {
  final dir = _findMaterialFonts();
  var robotoLoaded = false;
  if (dir != null) {
    final files = dir.listSync().whereType<File>().toList();
    await _loadFont(
      'MaterialIcons',
      files.where((f) => f.path.toLowerCase().contains('materialicons')).toList(),
    );
    final roboto =
        files.where((f) => f.path.toLowerCase().contains('roboto')).toList();
    if (roboto.isNotEmpty) {
      await _loadFont('Roboto', roboto);
      robotoLoaded = true;
    }
  }
  if (!robotoLoaded) {
    const win = 'C:/Windows/Fonts';
    await _loadFont('Roboto', [
      File('$win/segoeui.ttf'),
      File('$win/seguisb.ttf'),
      File('$win/segoeuib.ttf'),
      File('$win/seguibl.ttf'),
    ]);
  }
}

Future<void> _capture(String name) async {
  await expectLater(
    find.byKey(_shotKey),
    matchesGoldenFile('screenshots/$name.png'),
  );
}

void main() {
  setUpAll(_loadFonts);

  testWidgets('Assignment 2 flow + screenshots', (tester) async {
    // iPhone-like screen: 390 x 844 logical pixels @3x
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3.0;
    tester.view.padding = const FakeViewPadding(top: 141, bottom: 102);
    tester.view.viewPadding = const FakeViewPadding(top: 141, bottom: 102);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const RepaintBoundary(key: _shotKey, child: Assignment2App()),
    );

    // Load the profile photo before taking pictures
    await tester.runAsync(() async {
      final context = tester.element(find.byType(SplashScreen));
      await precacheImage(const AssetImage(A2Student.avatar), context);
    });

    // 1. Splash (logo animation finished)
    await tester.pump(const Duration(milliseconds: 1700));
    await _capture('01_splash');

    // After 3 seconds Home opens automatically
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    await _capture('02_home');

    // 2. Drawer menu
    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await _capture('03_drawer');

    // Drawer -> List screen (Navigator.push)
    await tester.tap(find.text('Cities List'));
    await tester.pumpAndSettle();
    expect(find.byType(ListScreen), findsOneWidget);
    await _capture('04_list');

    // List item -> Detail (Hero)
    await tester.tap(find.text('Islamabad'));
    await tester.pumpAndSettle();
    await _capture('05_city_detail');

    // Back (Navigator.pop)
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(ListScreen), findsOneWidget);

    // Scroll the ListView
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    await _capture('06_list_scrolled');

    // Drawer -> About
    await tester.tap(find.byTooltip('Open menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About Me'));
    await tester.pumpAndSettle();
    expect(find.byType(AboutScreen), findsOneWidget);
    await _capture('07_about');

    // Scroll: SliverAppBar collapses, GridView shows
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -420));
    await tester.pumpAndSettle();
    await _capture('08_about_grid');

    // Grid item -> Detail (Hero)
    await tester.tap(find.text('Flutter'));
    await tester.pumpAndSettle();
    await _capture('09_skill_detail');

    // Back to About, then back to Home
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
