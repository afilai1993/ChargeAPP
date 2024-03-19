part of 'business_home_screen.dart';

class HomeMineScreen extends StatefulWidget {
  const HomeMineScreen({super.key});

  @override
  State<HomeMineScreen> createState() => _HomeMineScreenState();
}

class _HomeMineScreenState extends State<HomeMineScreen>
    with StateAutoDisposeOwner, AutomaticKeepAliveClientMixin {
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    watchLogin.listen((event) {
      if (event != isLogin) {
        setState(() {
          isLogin = event;
        });
      }
    }).bind(this);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(S.current.user_center),
        actions: [
          IconButton(
              onPressed: () {
                context.navigateTo("/settings");
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ProfileHeader(isLogin),
            _BalanceProfile(
              rechargeBalance: "1.00",
              bonusBalance: "0.01",
            ),
            _MineMenuGroupContainer(
              S.current.all_order,
              children: [
                _MenuItem(S.current.all_order, icon: "ic_order_all.png",
                    onClick: () {
                  showToast("获取所有订单");
                }),
                _MenuItem(S.current.charging,
                    icon: "ic_order_charging.png", onClick: () {}),
                _MenuItem(S.current.refunded,
                    icon: "ic_order_refunded.png", onClick: () {}),
                _MenuItem(S.current.not_refunded,
                    icon: "ic_order_not_refunded.png", onClick: () {}),
                _MenuItem(S.current.not_started,
                    icon: "ic_order_not_started.png", onClick: () {}),
              ],
            ),
            _MineMenuGroupContainer(
              S.current.frequently_used_entrances,
              children: [
                _MenuItem(S.current.car_manager,
                    icon: "ic_menu_car_manager.png", onClick: () {
                  context.navigateTo("/scan/bluetooth");
                }),
                _MenuItem(S.current.helper_center,
                    icon: "ic_menu_helper_center.png", onClick: () {}),
                _MenuItem(S.current.about_us,
                    icon: "ic_menu_about_us.png", onClick: () {}),
                _MenuItem(S.current.coupon_package,
                    icon: "ic_menu_about_us.png", onClick: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final bool isLogin;

  const _ProfileHeader(this.isLogin, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> info;
    if (isLogin) {
      info = [
        StreamBuilder(
            stream: userStore.watchValue<String>("nickName"),
            builder: (_, snap) {
              return Text(snap.data ?? "");
            }),
        StreamBuilder(
            stream: userStore.watchValue<String>("email"),
            builder: (_, snap) {
              return Text(snap.data ?? "");
            }),
      ];
    } else {
      info = [Text(S.current.please_login)];
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Ink(
            child: InkWell(
              onTap: () {
                context.navigateTo(isLogin ? "/profile" : "/login");
              },
              child: StreamBuilder(
                  stream: userStore.watchValue<String>("avatar"),
                  builder: (_, snap) {
                    return GPAvatar(
                      snap.data ?? "",
                      iconSize: 48,
                    );
                  }),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: info,
            ),
          )),
          _ProfileMenuItem(
              name: S.current.recharge,
              icon: const GPAssetImageWidget(
                "ic_recharge.png",
                width: 25,
                height: 25,
              )),
          const SizedBox(
            width: 8,
          ),
          _ProfileMenuItem(
              name: S.current.details_refunds,
              icon: const GPAssetImageWidget(
                "ic_details_refunds.png",
                width: 25,
                height: 25,
              )),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final String name;
  final Widget icon;

  const _ProfileMenuItem({required this.name, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [icon, Text(name)],
    );
  }
}

class _BalanceProfile extends StatelessWidget {
  final String rechargeBalance;
  final String bonusBalance;

  const _BalanceProfile(
      {required this.rechargeBalance, required this.bonusBalance, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.fill,
            image: Image.asset("public/images/bg_shading.png").image),
      ),
      child: Row(
        children: [
          Expanded(
              child: _BalanceItem(
            name: S.current.recharge_balance,
            value: rechargeBalance,
          )),
          Container(
            color: context.onBackgroundColor,
            width: 1,
            height: 20,
          ),
          Expanded(
            child: _BalanceItem(
              name: S.current.bonus_balance,
              value: bonusBalance,
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceItem extends StatelessWidget {
  final String name;
  final String value;

  const _BalanceItem({required this.name, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(color: context.onPrimary),
        ),
        Text(
          value,
          style: TextStyle(color: context.onPrimary),
        ),
      ],
    );
  }
}

class _MineMenuGroupContainer extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _MineMenuGroupContainer(this.title,
      {required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    // return  GridView.count(
    //   physics: const NeverScrollableScrollPhysics(),
    //   crossAxisCount: 4,
    //   children: [Container(
    //     width: 100,
    //     height: 100,
    //     child: Text("1"),
    //   )],
    // );

    return Ink(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(title),
              ))
            ],
          ),
          GridView.count(
            shrinkWrap: true,
            childAspectRatio: 1.3,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 5,
            children: children,
          )
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String name;
  final String icon;
  final Function() onClick;

  const _MenuItem(this.name,
      {required this.icon, required this.onClick, super.key});

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: onClick,
        child: Column(
          children: [
            GPAssetImageWidget(
              icon,
              width: 30,
              height: 30,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(name, style: const TextStyle(fontSize: 10))
          ],
        ),
      ),
    );
  }
}
