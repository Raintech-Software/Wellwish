import 'package:ww_core/ww_core.dart';

import 'bootstrap.dart';

/// flutter run --flavor prod -t lib/main_prod.dart
Future<void> main() => bootstrap(Flavor.prod);
