import 'package:chargestation/component/component.dart';
import 'package:chargestation/component/status_page.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/domain/domain.dart';
import 'package:chargestation/infrastructure/dispose.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:geolocator/geolocator.dart';

part 'business_home_index_screen.dart';

part 'business_home_mine_screen.dart';

class BusinessHomeScreen extends StatelessWidget {
  final PageController pageController = PageController();

  BusinessHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GPScaffold(
      bottomNavigationBar: StreamBuilder(
        stream: _watchPage(pageController),
        builder: (_, snapshot) => _HomeNavigationBar(
          selectedIndex: snapshot.data ?? 0,
          onTabClick: (index) {
            pageController.jumpToPage(index);
          },
        ),
      ),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomeScreenPageControllerProvider(pageController,
              child: const HomeIndexScreen()),
          HomeScreenPageControllerProvider(
            pageController,
            child: const HomeMineScreen(),
          )
        ],
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

class HomeScreenPageControllerProvider extends InheritedWidget {
  final PageController pageController;

  const HomeScreenPageControllerProvider(this.pageController,
      {required super.child, super.key});

  @override
  bool updateShouldNotify(HomeScreenPageControllerProvider oldWidget) {
    return pageController != oldWidget.pageController;
  }

  static PageController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<HomeScreenPageControllerProvider>()!
        .pageController;
  }
}

class _HomeNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabClick;

  const _HomeNavigationBar(
      {required this.selectedIndex, required this.onTabClick, super.key});

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.paddingOf(context);
    return SizedBox(
      height: 56 + padding.bottom,
      child: Row(
        children: [
          Expanded(
            child: _HomeNavigationBarItem(
              name: S.current.nearby,
              onClick: () {
                onTabClick(0);
              },
              iconName: selectedIndex == 0
                  ? "ic_location_selected.png"
                  : "ic_location_unselected.png",
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: context.onSurfaceVariant,
                    width: 1,
                    style: BorderStyle.solid),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _HomeNavigationBarItem(
                        name: S.current.scan,
                        onClick: () {
                          context.navigateTo("/scan");
                        },
                        color: context.onBackgroundColor,
                        iconName: "ic_scan.png"),
                  ),
                  Expanded(
                    child: _HomeNavigationBarItem(
                        name: S.current.numbering,
                        onClick: () {
                          onTabClick(0);
                        },
                        color: context.onBackgroundColor,
                        iconName: "ic_gun_numbering.png"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _HomeNavigationBarItem(
              name: S.current.mine,
              onClick: () {
                onTabClick(1);
              },
              iconName: selectedIndex == 1
                  ? "ic_mine_selected.png"
                  : "ic_mine_unselected.png",
            ),
          )
        ],
      ),
    );
  }
}

class _HomeNavigationBarItem extends StatelessWidget {
  final String iconName;
  final String name;
  final Function() onClick;
  final Color? color;

  const _HomeNavigationBarItem(
      {required this.onClick,
      required this.iconName,
      required this.name,
      this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Column(
        children: [
          GPAssetImageWidget(
            iconName,
            width: 26,
            height: 26,
          ),
          Text(
            name,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
