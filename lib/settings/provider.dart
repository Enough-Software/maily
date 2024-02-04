import 'package:enough_mail_app/enough_mail_app.dart';
import 'package:flutter/widgets.dart';

/// Shows how to override the default settings
class CustomSettingsNotifier extends SettingsNotifier {
  /// Creates a new [CustomSettingsNotifier]
  CustomSettingsNotifier({
    super.settings,
  });

  @override
  String getSignatureHtmlGlobal(BuildContext context) =>
      state.signatureHtml ?? '<p>---<br/>${context.text.signature}</p>';

  @override
  String getSignaturePlainGlobal(BuildContext context) =>
      state.signaturePlain ?? '---\n${context.text.signature}';
}
