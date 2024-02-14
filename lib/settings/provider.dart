import 'package:enough_mail_app/enough_mail_app.dart';

/// Shows how to override the default settings
class CustomSettingsNotifier extends SettingsNotifier {
  /// Creates a new [CustomSettingsNotifier]
  CustomSettingsNotifier();

  @override
  String getSignatureHtmlGlobal() =>
      state.signatureHtml ?? '<p>---<br/>${ref.text.signature}</p>';

  @override
  String getSignaturePlainGlobal() =>
      state.signaturePlain ?? '---\n${ref.text.signature}';
}
