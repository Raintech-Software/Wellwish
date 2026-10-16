import 'package:google_sign_in/google_sign_in.dart';
import 'package:ww_core/ww_core.dart';

/// Gets a Google ID token for the backend (§6.2). Turned on by the GOOGLE_SERVER_CLIENT_ID
/// dart-define; without it the Google button is hidden (feature flag).
abstract class GoogleSignInService {
  bool get enabled;

  /// The ID token, or null if the user cancelled.
  Future<String?> idToken();
}

class PluginGoogleSignInService implements GoogleSignInService {
  PluginGoogleSignInService(this._config);

  final AppConfig _config;
  bool _initialized = false;

  @override
  bool get enabled => _config.googleSignInEnabled;

  @override
  Future<String?> idToken() async {
    final google = GoogleSignIn.instance;
    if (!_initialized) {
      await google.initialize(serverClientId: _config.googleServerClientId);
      _initialized = true;
    }
    try {
      final account = await google.authenticate();
      return account.authentication.idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }
}
