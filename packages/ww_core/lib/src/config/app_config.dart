/// Which build the app is: dev (PC + emulator), staging (test server) or prod.
enum Flavor { dev, staging, prod }

/// Per-flavor settings. Override at build/run time with `--dart-define`:
/// - `API_BASE_URL=http://192.168.1.20:8000` (e.g. a real phone on your Wi-Fi)
/// - `GOOGLE_SERVER_CLIENT_ID=…apps.googleusercontent.com` (turns on Google sign-in)
class AppConfig {
  const AppConfig({required this.flavor, required this.apiBaseUrl, this.googleServerClientId = ''});

  factory AppConfig.forFlavor(Flavor flavor) {
    const override = String.fromEnvironment('API_BASE_URL');
    const googleClient = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
    final base = override.isNotEmpty ? override : _defaults[flavor]!;
    return AppConfig(flavor: flavor, apiBaseUrl: _trimSlash(base), googleServerClientId: googleClient);
  }

  static const _defaults = {
    // The Android emulator reaches the developer's PC at 10.0.2.2.
    Flavor.dev: 'http://10.0.2.2:8000',
    Flavor.staging: 'https://api-staging.wellwish.in',
    Flavor.prod: 'https://api.wellwish.in',
  };

  final Flavor flavor;

  /// e.g. http://10.0.2.2:8000. The generated client's paths already start with `/v1/`.
  final String apiBaseUrl;

  /// OAuth "Web" client id the backend accepts. Empty = Google sign-in is hidden.
  final String googleServerClientId;

  bool get isProd => flavor == Flavor.prod;

  bool get googleSignInEnabled => googleServerClientId.isNotEmpty;

  /// REST base: `.../v1`
  String get apiV1 => '$apiBaseUrl/v1';

  /// WebSocket base: http→ws, https→wss (ARCHITECTURE §6.14).
  String get wsBaseUrl {
    final uri = Uri.parse(apiBaseUrl);
    return uri.replace(scheme: uri.scheme == 'https' ? 'wss' : 'ws').toString();
  }

  static String _trimSlash(String s) => s.endsWith('/') ? s.substring(0, s.length - 1) : s;
}
