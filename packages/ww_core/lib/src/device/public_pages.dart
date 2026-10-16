import 'package:url_launcher/url_launcher.dart';
import 'package:ww_api/ww_api.dart';

/// The public pages the API serves (ARCHITECTURE §6.20): the legal pages and the account
/// deletion page. Their full links come from the app-config (`legalUrls`).
enum PublicPage { terms, privacy, refunds, partnerTerms, deleteAccount }

extension PublicPageLinks on LegalUrlsOut {
  String linkOf(PublicPage page) => switch (page) {
    PublicPage.terms => terms,
    PublicPage.privacy => privacy,
    PublicPage.refunds => refunds,
    PublicPage.partnerTerms => partnerTerms,
    PublicPage.deleteAccount => deleteAccount,
  };
}

/// [url] in the app's [language] (`?l=en|hi|or`), keeping any other query.
Uri publicPageUri(String url, String language) {
  final uri = Uri.parse(url);
  return uri.replace(queryParameters: {...uri.queryParameters, 'l': language});
}

/// Opens [url] in the phone's browser, in the app's [language]. False: no browser to open it.
Future<bool> openPublicPage(String url, String language) =>
    launchUrl(publicPageUri(url, language), mode: LaunchMode.externalApplication);
