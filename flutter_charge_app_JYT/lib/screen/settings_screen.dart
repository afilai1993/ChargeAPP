import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/repository/contants.dart';
import 'package:chargestation/repository/store/settings_store.dart';

import '../infrastructure/infrastructure.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(S.current.settings),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _SettingsItem(
                icon: const _SettingsIcon(Icons.language),
                name: S.current.language,
                value: StreamBuilder(
                  initialData: settingsStore.language,
                  stream: settingsStore.watchLanguage,
                  builder: (_, snapShot) =>
                      Text((snapShot.data ?? settingsStore.language).name),
                ),
                onClick: () {
                  changeLanguage(context);
                }),
            _SettingsItem(
              icon: const _SettingsIcon(Icons.invert_colors),
              name: S.current.theme,
              value: StreamBuilder(
                initialData: settingsStore.themeType,
                stream: settingsStore.watchThemeType,
                builder: (_, snapShot) =>
                    Text((snapShot.data ?? settingsStore.themeType).name),
              ),
              onClick: () {
                changeTheme(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void changeLanguage(BuildContext context) {
    final List<Language> list = Language.supportLanguageList;
    _showListDialog(context,
        title: S.current.language,
        menus: list.map((e) => e.name).toList(),
        selectedIdx: settingsStore.language.value, menuSelectCallBack: (index) {
      settingsStore.language = list[index];
    });
  }

  void changeTheme(BuildContext context) {
    final List<ThemeType> list = ThemeType.supportThemeList;
    _showListDialog(context,
        title: S.current.theme,
        menus: list.map((e) => e.name).toList(),
        selectedIdx: settingsStore.themeType.value,
        menuSelectCallBack: (index) {
      settingsStore.themeType = list[index];
    });
  }
}

class _SettingsItem extends StatelessWidget {
  final Widget icon;
  final String name;
  final VoidCallback onClick;
  final Widget value;
  final bool isShowArrow;

  const _SettingsItem(
      {required this.icon,
      required this.name,
      required this.onClick,
      required this.value,
      this.isShowArrow = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(children: [
            icon,
            const SizedBox(
              width: 12,
            ),
            Expanded(child: Text(name)),
            const SizedBox(
              width: 12,
            ),
            value,
            if (isShowArrow)
              const SizedBox(
                width: 12,
              ),
            if (isShowArrow) const RightArrowIcon()
          ]),
        ),
      ),
    );
  }
}

class _SettingsIcon extends StatelessWidget {
  final IconData icon;

  const _SettingsIcon(this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 30,
    );
  }
}

///列表弹窗
Future<void> _showListDialog(BuildContext context,
    {required String title,
    required List<String> menus,
    int selectedIdx = -1,
    Function(int which)? menuSelectCallBack}) async {
  BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8));
  EdgeInsetsGeometry margin =
      const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8);

  List<Widget> widgets = menus
      .asMap()
      .map((index, item) {
        var bgColor = index == selectedIdx
            ? context.primaryContainerColor
            : Colors.transparent;
        return MapEntry(
            index,
            Container(
              margin: margin,
              child: Material(
                color: bgColor,
                borderRadius: borderRadius,
                child: InkWell(
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 12, bottom: 12),
                    child: Text(
                      '$item',
                      style: TextStyle(
                          fontSize: 16,
                          color: index == selectedIdx
                              ? context.primaryColor
                              : null),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    menuSelectCallBack?.call(index);
                  },
                ),
              ),
            ));
      })
      .values
      .toList();

  await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("${title}"),
          children: widgets,
        );
      });
}
