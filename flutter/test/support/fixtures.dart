import 'dart:convert';
import 'dart:io';

/// The shared reference responses, read straight from the monorepo (tests
/// run with the package root as working directory).
const String sharedFixturesPath = '../api/fixtures';

String readFixture(String fileName) =>
    File('$sharedFixturesPath/$fileName').readAsStringSync();

Object? decodeFixture(String fileName) => jsonDecode(readFixture(fileName));

Map<String, dynamic> fixtureObject(String fileName) =>
    decodeFixture(fileName)! as Map<String, dynamic>;

List<Map<String, dynamic>> fixtureList(String fileName) =>
    (decodeFixture(fileName)! as List<dynamic>).cast<Map<String, dynamic>>();

/// Fixture loader for the fake API in tests.
Future<String> loadSharedFixture(String fileName) async =>
    readFixture(fileName);
