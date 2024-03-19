import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/domain/device/charge_device.dart';
import 'package:chargestation/domain/domain.dart';
import 'package:chargestation/generated/l10n.dart';
import 'package:chargestation/infrastructure/dispose.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:chargestation/repository/data/po.dart';

class HouseholdDeviceScreen extends StatefulWidget {
  const HouseholdDeviceScreen({super.key});

  @override
  State<HouseholdDeviceScreen> createState() => _HouseholdDeviceScreenState();
}

class _HouseholdDeviceScreenState extends State<HouseholdDeviceScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GPScaffold(
      appBar: GPAppbar(
        automaticallyImplyLeading: false,
        title: GPAppBarTitle(S.current.home),
        actions: [
          IconButton(
            onPressed: () {
              context.navigateTo("/scan/bluetooth");
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: _HouseholdDeviceListScreen(deviceType: DeviceType.bluetooth),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _HouseholdDeviceListScreen extends StatefulWidget {
  final DeviceType deviceType;

  const _HouseholdDeviceListScreen({required this.deviceType, super.key});

  @override
  State<_HouseholdDeviceListScreen> createState() =>
      _HouseholdDeviceListScreenState();
}

class _HouseholdDeviceListScreenState
    extends State<_HouseholdDeviceListScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            findCase<HouseholdDeviceCase>().watchDeviceList(widget.deviceType),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final list = snapshot.data ?? const [];
            if (list.isEmpty) {
              return GPEmptyStatusPage(
                action: GPFilledButton(
                    text: S.current.add_device,
                    onPressed: () {
                      context.navigateTo("/scan/bluetooth");
                    }),
              );
            } else {
              return ListView.builder(
                  padding:
                      const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                  itemCount: list.length,
                  itemBuilder: (_, index) =>
                      _HouseholdDeviceItem(item: list[index]));
            }
          } else {
            return const GPRefreshStatusPage();
          }
        });
  }
}

class _HouseholdDeviceItem extends StatefulWidget {
  final HouseholdDeviceItemVO item;

  const _HouseholdDeviceItem({required this.item, super.key});

  @override
  State<_HouseholdDeviceItem> createState() => _HouseholdDeviceItemState();
}

class _HouseholdDeviceItemState extends State<_HouseholdDeviceItem>
    with StateAutoDisposeOwner {
  HouseholdChargeDeviceConnectState connectState =
      HouseholdChargeDeviceConnectState.idle;
  bool isCharge = false;
  bool? connectionStatus;

  String? mChargeStatus;
  final requestChargeLoading = BoolStateRef();

  @override
  void initState() {
    super.initState();
    findCase<HouseholdDeviceCase>()
        .watchConnectState(widget.item.address)
        .listen((event) {
      if (event != connectState) {
        setState(() {
          connectState = event;
        });
      }
    }).bind(this);

    findCase<HouseholdDeviceCase>()
        .watchSynchroStatus(widget.item.address)
        .listen((event) {
      final currentChargeStatus = event?.connectorMain?.chargeStatus;
      final currentConnectionStatus = event?.connectorMain?.connectionStatus;
      if (mChargeStatus == currentChargeStatus &&
          connectionStatus == currentConnectionStatus) {
        return;
      }
      setState(() {
        isCharge = currentChargeStatus == 'charging';
        mChargeStatus = currentChargeStatus;
        connectionStatus = currentConnectionStatus;
      });
    }).bind(this);
  }

  @override
  Widget build(BuildContext context) {
    final showChargeIcon =
        connectState == HouseholdChargeDeviceConnectState.connected &&
            (mChargeStatus == "charging" ||
                mChargeStatus == "wait" ||
                mChargeStatus == "finish") &&
            connectionStatus == true;
    return Ink(
      decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: InkWell(
        radius: 4,
        onTap: () {
          context.navigateTo("/household/device",
              arguments: {"address": widget.item.address});
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: context.isDarkMode ? Colors.white : null,
                  border: Border.all(
                      color: context.primaryColor,
                      width: 1,
                      style: BorderStyle.solid),
                ),
                child: const Center(
                  child: GPAssetImageWidget(
                    "ic_device_item.png",
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.name),
                  const SizedBox(
                    height: 2,
                  ),
                  _DeviceConnectStateWidget(
                    state: connectState,
                  )
                ],
              )),
              Visibility(
                visible: connectState ==
                        HouseholdChargeDeviceConnectState.idle ||
                    connectState == HouseholdChargeDeviceConnectState.connected,
                child: _DeviceIconButton(
                  iconName: "link.svg",
                  color: connectState ==
                          HouseholdChargeDeviceConnectState.connected
                      ? context.successColor
                      : null,
                  onClick: () {
                    final isConnected = connectState ==
                        HouseholdChargeDeviceConnectState.connected;
                    if (isConnected) {
                      findCase<HouseholdDeviceCase>()
                          .disconnect(widget.item.address);
                    } else {
                      uiTask.run(findCase<HouseholdDeviceCase>()
                          .requestConnect(widget.item.address));
                    }
                  },
                ),
              ),
              if (showChargeIcon)
                const SizedBox(
                  width: 8,
                ),
              Visibility(
                visible: showChargeIcon,
                child: RefProvider(
                  requestChargeLoading,
                  builder: (_, ref, child) {
                    if (ref.value == true) {
                      return const GPLoadingWidget(
                        size: 24,
                      );
                    }
                    return _DeviceIconButton(
                      iconName: "zap.svg",
                      color: isCharge ? context.successColor : null,
                      onClick: () {
                        uiTask
                            .options(
                                UITaskOption(loadingRef: requestChargeLoading))
                            .run(findCase<HouseholdDeviceCase>()
                                .requestCharge(widget.item.address, !isCharge))
                            .onSuccess((result) {
                          if (result) {
                            showToast(S.current.request_success);
                          } else {
                            showToast(S.current.request_fail);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeviceConnectStateWidget extends StatelessWidget {
  final HouseholdChargeDeviceConnectState state;

  const _DeviceConnectStateWidget({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    final String text;
    final isConnected = state == HouseholdChargeDeviceConnectState.connected;
    switch (state) {
      case HouseholdChargeDeviceConnectState.idle:
        text = S.current.connect_status_idle;
        break;
      case HouseholdChargeDeviceConnectState.connecting:
        text = S.current.connect_status_connecting;
        break;
      case HouseholdChargeDeviceConnectState.ensureKey:
        text = S.current.connect_status_ensure_key;
        break;
      case HouseholdChargeDeviceConnectState.connected:
        text = S.current.connect_status_connected;
        break;
    }
    return Row(
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
              color:
                  isConnected ? context.successColor : context.onSurfaceVariant,
              borderRadius: const BorderRadius.all(Radius.circular(2.5))),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          text,
          style: TextStyle(color: context.onSurfaceVariant, fontSize: 11),
        )
      ],
    );
  }
}

class _DeviceIconButton extends StatelessWidget {
  final String iconName;
  final Color? color;
  final VoidCallback? onClick;

  const _DeviceIconButton(
      {this.color, this.onClick, required this.iconName, super.key});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: InkWell(
        onTap: onClick,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(
                color: color ?? context.onSurfaceVariant,
                width: 1,
                style: BorderStyle.solid),
          ),
          child: Center(
            child: GPAssetSvgWidget(
              iconName,
              width: 12,
              height: 12,
              color: color ?? context.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
