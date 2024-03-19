import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/generated/l10n.dart';
import 'package:chargestation/screen/household/household_device_screen.dart';
import 'package:chargestation/screen/household/household_mine_screen.dart';
import 'package:chargestation/screen/household/household_task_screen.dart';
import 'package:collection/collection.dart';

class HouseholdHomeScreen extends StatefulWidget {
  HouseholdHomeScreen({super.key});

  @override
  State<HouseholdHomeScreen> createState() => _HouseholdHomeScreenState();
}

class _HouseholdHomeScreenState extends State<HouseholdHomeScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return GPScaffold(
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HouseholdDeviceScreen(),
            HouseholdTaskScreen(),
            HouseholdMineScreen()
          ],
        ),
        bottomNavigationBar: StreamBuilder(
          stream: _watchPage(pageController),
          builder: (_, snapshot) => _HouseholdBottomNavigator(
            index: snapshot.data ?? 0,
            items: [
              _HouseholdBottomItem(icon: "home.svg", name: S.current.home),
              _HouseholdBottomItem(icon: "folder.svg", name: S.current.task),
              _HouseholdBottomItem(icon: "profile.svg", name: S.current.mine),
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
    return SizedBox(
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
        padding: const EdgeInsets.symmetric(vertical: 4.0),
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
