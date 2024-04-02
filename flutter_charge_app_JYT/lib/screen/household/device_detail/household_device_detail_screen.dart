import 'dart:async';

import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/domain/device/charge_device.dart';
import 'package:chargestation/domain/domain.dart';
import 'package:chargestation/generated/l10n.dart';
import 'package:chargestation/infrastructure/dispose.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wheel_slider/wheel_slider.dart';

part 'device_profile_screen.dart';

part 'device_record_screen.dart';

part 'device_reminder_screen.dart';

part 'device_settings_screen.dart';

class HouseholdDeviceDetailScreen extends StatefulWidget {
  final String address;

  const HouseholdDeviceDetailScreen({required this.address, super.key});

  @override
  State<HouseholdDeviceDetailScreen> createState() =>
      _HouseholdDeviceDetailScreenState();
}

class _HouseholdDeviceDetailScreenState
    extends State<HouseholdDeviceDetailScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return GPScaffold(
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _DeviceProfileScreen(
              address: widget.address,
            ),
            _DeviceRecordScreen(
              address: widget.address,
            ),
            _DeviceReminderScreen(
              address: widget.address,
            ),
            _DeviceSettingsScreen(
              address: widget.address,
            ),
          ],
        ),
        bottomNavigationBar: StreamBuilder(
          stream: _watchPage(pageController),
          builder: (_, snapshot) => _HouseholdBottomNavigator(
            index: snapshot.data ?? 0,
            items: [
              _HouseholdBottomItem(icon: "charge.svg", name: S.current.device),
              _HouseholdBottomItem(
                  icon: "bullet_list.svg", name: S.current.record),
              _HouseholdBottomItem(
                  icon: "bell_notification.svg", name: S.current.reminder),
              _HouseholdBottomItem(icon: "cog.svg", name: S.current.settings),
            ],
            onTabClick: (index) {
              pageController.jumpToPage(index);
            },
          ),
        ));
  }
}

class _HouseholdBottomNavigator extends StatelessWidget {
  final int index;
  final List<_HouseholdBottomItem> items;
  final Function(int index) onTabClick;

  const _HouseholdBottomNavigator(
      {required this.index,
      required this.items,
      required this.onTabClick,
      super.key});

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.paddingOf(context);
    return Ink(
      child: SizedBox(
        height: 50 + padding.bottom,
        child: Column(
          children: [
            const GPDivider(),
            Expanded(
              child: Row(
                  children: items
                      .mapIndexed((index, element) => Expanded(
                            child: _HouseholdBottomNavigatorItem(
                              name: element.name,
                              icon: element.icon,
                              selected: index == this.index,
                              onClick: () {
                                onTabClick(index);
                              },
                            ),
                          ))
                      .toList(growable: false)),
            ),
            SizedBox(
              height: padding.bottom,
            )
          ],
        ),
      ),
    );
  }
}

class _HouseholdBottomItem {
  final String icon;
  final String name;

  const _HouseholdBottomItem({
    required this.icon,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _HouseholdBottomItem &&
          runtimeType == other.runtimeType &&
          icon == other.icon &&
          name == other.name;

  @override
  int get hashCode => icon.hashCode ^ name.hashCode;
}

class _HouseholdBottomNavigatorItem extends StatelessWidget {
  final String icon;
  final String name;
  final VoidCallback onClick;
  final bool selected;

  const _HouseholdBottomNavigatorItem(
      {required this.icon,
      required this.name,
      required this.onClick,
      required this.selected,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GPAssetSvgWidget(
              icon,
              width: 18,
              height: 18,
              color: selected ? context.primaryColor : context.onSurface,
            ),
            const SizedBox(height: 2),
            Text(name,
                style: TextStyle(color: selected ? context.primaryColor : null))
          ],
        ),
      ),
    );
  }
}

Stream<int> _watchPage(PageController pageController) =>
    Stream.multi((controller) {
      controller.add(pageController.page?.toInt() ?? 0);
      void onChanged() {
        controller.add(pageController.page?.toInt() ?? 0);
      }

      pageController.addListener(onChanged);
      controller.onCancel = () {
        pageController.removeListener(onChanged);
      };
    });
