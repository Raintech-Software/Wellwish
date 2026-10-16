import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ww_core/ww_core.dart';

/// Steps and location points kept on the phone while there's no network (ARCHITECTURE §6.11):
/// "If the network drops, the app keeps the points and step taps with their timestamps and
/// uploads them when back online." Saved to a small file in the app's private storage, so they
/// survive the app being closed. One outbox per partner: another partner logging in on the
/// same phone never sees or sends them (they wait for this partner's next login).
abstract class VisitOutbox {
  Future<List<Map<String, dynamic>>> steps();
  Future<void> addStep(Map<String, dynamic> step);
  Future<void> removeStep(Map<String, dynamic> step);

  Future<Map<String, List<TrackPoint>>> points();
  Future<void> addPoint(String bookingId, TrackPoint point);

  /// Removes the points [sent] (uploaded); points kept meanwhile stay.
  Future<void> removePoints(String bookingId, List<TrackPoint> sent);
}

/// At most this many points per job are kept (about 5 hours at one every 10 s); beyond it the
/// oldest go, so the latest route is kept.
const maxKeptPoints = 2000;

/// The outbox file. One change at a time (a queue), each saved to a temporary file first and
/// then moved over the old one, so a crash mid-write never leaves half a file. A file that
/// can't be read is kept aside (`.bad`) rather than silently dropped.
class FileVisitOutbox implements VisitOutbox {
  FileVisitOutbox({required this.partnerId, Future<Directory> Function()? directory})
    : _directory = directory ?? getApplicationSupportDirectory;

  /// Whose outbox (the partner's user id): its own file.
  final String partnerId;
  final Future<Directory> Function() _directory;
  Future<Map<String, dynamic>>? _loading;
  File? _file;
  Future<void> _queue = Future.value();

  Future<Map<String, dynamic>> _data() => _loading ??= _load();

  Future<Map<String, dynamic>> _load() async {
    final dir = await _directory();
    final name = partnerId.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    final file = _file = File('${dir.path}/visit_outbox_$name.json');
    if (await file.exists()) {
      try {
        final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        data['steps'] as List<dynamic>;
        data['points'] as Map<String, dynamic>;
        return data;
      } catch (_) {
        try {
          await file.rename('${file.path}.bad');
        } catch (_) {
          // nothing more to do: start again with an empty outbox
        }
      }
    }
    return {'steps': <dynamic>[], 'points': <String, dynamic>{}};
  }

  /// Runs [change] after the ones before it, then saves.
  Future<T> _change<T>(T Function(Map<String, dynamic> data) change) {
    final done = Completer<T>();
    _queue = _queue.then((_) async {
      try {
        final data = await _data();
        final result = change(data);
        final file = _file!;
        final temp = File('${file.path}.tmp');
        await temp.writeAsString(jsonEncode(data), flush: true);
        await temp.rename(file.path);
        done.complete(result);
      } catch (e, st) {
        done.completeError(e, st);
      }
    });
    return done.future;
  }

  @override
  Future<List<Map<String, dynamic>>> steps() async => [
    for (final s in (await _data())['steps'] as List<dynamic>) Map<String, dynamic>.from(s as Map),
  ];

  @override
  Future<void> addStep(Map<String, dynamic> step) => _change((data) => (data['steps'] as List<dynamic>).add(step));

  @override
  Future<void> removeStep(Map<String, dynamic> step) => _change(
    (data) => (data['steps'] as List<dynamic>).removeWhere(
      (s) => (s as Map)['bookingId'] == step['bookingId'] && s['step'] == step['step'],
    ),
  );

  @override
  Future<Map<String, List<TrackPoint>>> points() async {
    final raw = (await _data())['points'] as Map<String, dynamic>;
    return {
      for (final e in raw.entries)
        e.key: [for (final p in e.value as List<dynamic>) TrackPoint.fromJson(Map<String, dynamic>.from(p as Map))],
    };
  }

  @override
  Future<void> addPoint(String bookingId, TrackPoint point) => _change((data) {
    final raw = data['points'] as Map<String, dynamic>;
    final list = (raw[bookingId] as List<dynamic>?) ?? <dynamic>[];
    list.add(point.toJson());
    if (list.length > maxKeptPoints) list.removeRange(0, list.length - maxKeptPoints);
    raw[bookingId] = list;
  });

  @override
  Future<void> removePoints(String bookingId, List<TrackPoint> sent) => _change((data) {
    final raw = data['points'] as Map<String, dynamic>;
    final list = raw[bookingId] as List<dynamic>?;
    if (list == null) return;
    final times = {for (final p in sent) p.at.microsecondsSinceEpoch};
    list.removeWhere((p) => times.contains(DateTime.parse((p as Map)['at'] as String).microsecondsSinceEpoch));
    if (list.isEmpty) raw.remove(bookingId);
  });
}

/// In memory (tests).
class MemoryVisitOutbox implements VisitOutbox {
  final List<Map<String, dynamic>> stepList = [];
  final Map<String, List<TrackPoint>> pointMap = {};

  @override
  Future<List<Map<String, dynamic>>> steps() async => List.of(stepList);

  @override
  Future<void> addStep(Map<String, dynamic> step) async => stepList.add(step);

  @override
  Future<void> removeStep(Map<String, dynamic> step) async =>
      stepList.removeWhere((s) => s['bookingId'] == step['bookingId'] && s['step'] == step['step']);

  @override
  Future<Map<String, List<TrackPoint>>> points() async => {for (final e in pointMap.entries) e.key: List.of(e.value)};

  @override
  Future<void> addPoint(String bookingId, TrackPoint point) async {
    final list = pointMap[bookingId] ??= [];
    list.add(point);
    if (list.length > maxKeptPoints) list.removeRange(0, list.length - maxKeptPoints);
  }

  @override
  Future<void> removePoints(String bookingId, List<TrackPoint> sent) async {
    final list = pointMap[bookingId];
    if (list == null) return;
    final times = {for (final p in sent) p.at.microsecondsSinceEpoch};
    list.removeWhere((p) => times.contains(p.at.microsecondsSinceEpoch));
    if (list.isEmpty) pointMap.remove(bookingId);
  }
}

/// The outbox of one partner (their user id).
final visitOutboxProvider = Provider.family<VisitOutbox, String>(
  (ref, partnerId) => FileVisitOutbox(partnerId: partnerId),
);
