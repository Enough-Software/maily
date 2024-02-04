import 'package:enough_mail_app/enough_mail_app.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
class CustomSettingsUiElements extends _$CustomSettingsUiElements
    implements SettingsUiElements {
  @override
  void build() {}

  @override
  List<UiSettingsElement> generate(
    BuildContext context,
  ) {
    final text = context.text;
    final standardElements = SettingsUiElements.buildStandardElements(context);

    /// You can remove a standard element easily like this:
    // standardElements.removeType(UiSettingsType.welcome);
    // You can insert a new element at a specific position like this:
    // standardElements.insertAfter(UiSettingsType.accounts, newElement);

    return [
      ...standardElements,
      UiSettingsElement.divider(),
      UiSettingsElement(
        title: text.settingsDevelopment,
        onTap: () => context.pushNamed(Routes.settingsDevelopment),
      ),
    ];
  }
}
