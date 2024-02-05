import 'package:enough_mail_app/enough_mail_app.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
class CustomSettingsUiElements extends _$CustomSettingsUiElements
    implements SettingsUiElements {
  @override
  void build() {}

  @override
  List<UiSettingsElement> generate(
    WidgetRef ref,
  ) {
    final text = ref.text;
    final standardElements = SettingsUiElements.buildStandardElements(ref);

    /// You can remove a standard element easily like this:
    // standardElements.removeType(UiSettingsType.welcome);
    // You can insert a new element at a specific position like this:
    // standardElements.insertAfter(UiSettingsType.accounts, newElement);

    return [
      ...standardElements,
      UiSettingsElement.divider(),
      UiSettingsElement(
        title: text.settingsDevelopment,
        onTap: () => ref.context.pushNamed(Routes.settingsDevelopment),
      ),
    ];
  }
}
