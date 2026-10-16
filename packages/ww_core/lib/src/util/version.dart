/// True if [current] (e.g. "0.1.0" or "0.1.0+3") is older than [minimum] ("0.2.0").
/// Used for the force-update screen (min versions come from /v1/public/app-config).
bool isOlderVersion(String current, String minimum) {
  List<int> parts(String v) =>
      v.split('+').first.split('.').map((p) => int.tryParse(p.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0).toList();
  final a = parts(current);
  final b = parts(minimum);
  for (var i = 0; i < 3; i++) {
    final x = i < a.length ? a[i] : 0;
    final y = i < b.length ? b[i] : 0;
    if (x != y) return x < y;
  }
  return false;
}
