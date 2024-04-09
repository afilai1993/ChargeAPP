import 'dart:io';
import 'package:intl/intl.dart';
import 'package:chargestation/component/action_bottom_sheet_scaffold.dart';
import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/domain/device/bluetooth/bluetooth_charge_device.dart';
import 'package:chargestation/domain/domain.dart';
import 'package:chargestation/infrastructure/dispose.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:chargestation/infrastructure/utils/string_extension.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanBluetoothScreen extends StatefulWidget {
  const ScanBluetoothScreen({super.key});

  @override
  State<ScanBluetoothScreen> createState() => _ScanBluetoothState();
}

class _ScanBluetoothState extends State<ScanBluetoothScreen>
    with StateAutoDisposeOwner {
  final Map<String, ScanResult> scanMap = {};
  final Set<String> existDevice = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      startScan();
    });

    findCase<HouseholdDeviceCase>()
        .watchDeviceList(DeviceType.bluetooth)
        .listen((event) {
      if (event.isEmpty) {
        existDevice.clear();
        return;
      }
      existDevice.addAll(event.map((e) => e.address));
      bool isRemoved = false;
      final keys = List.of(scanMap.keys);
      for (var item in keys) {
        if (scanMap.remove(item) != null) {
          isRemoved = true;
        }
      }
      if (isRemoved) {
        setState(() {});
      }
    }).bind(this);

    FlutterBluePlus.onScanResults.listen((event) {
      if (event.isNotEmpty) {
        bool isAdd = false;
        for (var item in event) {
          final address = item.device.remoteId.str;
          if (!existDevice.contains(address) && !scanMap.containsKey(address)) {
            scanMap[address] = item;
            isAdd = true;
          }
        }
        if (isAdd) {
          setState(() {});
        }
      }
    }).bind(this);
  }

  @override
  void dispose() {
    super.dispose();
    FlutterBluePlus.stopScan().catchError((e) {});
  }

  void startScan() async {
    void requestScan() async {
      if (Platform.isAndroid) {
        final isLocationServiceEnabled =
            await Geolocator.isLocationServiceEnabled();
        if (!isLocationServiceEnabled) {
          showToast(S.current.tip_open_location_bluetooth);
          return;
        }
      }
      FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 15),
          withKeywords: const ["EVSE-"]).catchError((e, st) {
        loggerFactory.getLogger("ScanBlue").warn("扫描失败", e, st);
      });
    }

    final isSupported = await FlutterBluePlus.isSupported;
    if (!isSupported) {
      showToast(S.current.not_support_bluetooth);
      return;
    }
    final currentAdapterState = await FlutterBluePlus.adapterState
        .firstWhere((element) => element != BluetoothAdapterState.unknown);
    if (currentAdapterState != BluetoothAdapterState.on) {
      showToast(S.current.tip_open_bluetooth);
      return;
    }
    final permissionList = requestPermissionList();
    final isGranted = await PermissionUtils.checkPermissions(permissionList);
    if (isGranted) {
      requestScan();
      return;
    }
    if (!mounted) {
      return;
    }
    final isConfirm = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => GPMessageDialog(
              message: Platform.isIOS
                  ? S.current.request_scan_bluetooth_permission_by_ios
                  : S.current.request_scan_bluetooth_permission,
              onConfirm: () {
                dialogContext.navigateBack(true);
              },
              onCancel: () {
                dialogContext.navigateBack();
              },
            ));
    if (isConfirm == true) {
      final isRequestGranted =
          await PermissionUtils.requestPermissions(permissionList);
      //print("isRequestGranted:${isRequestGranted}");
      if (isRequestGranted) {
        requestScan();
      }
    }
  }

  List<Permission> requestPermissionList() {
    if (Platform.isIOS) {
      return const [];
    } else if (Platform.isAndroid) {
      return const [
        Permission.location,
        Permission.bluetoothScan,
        Permission.bluetooth
      ];
    } else {
      return const [];
    }
  }

  void connect(ScanResult scanResult) {
    Future save(String key) async {
      final name = scanResult.advertisementData.advName;
      final sn = name.substring(5);
      return findCase<HouseholdDeviceCase>().saveDevice(
          address: scanResult.device.remoteId.str,
          sn: sn,
          name: name,
          key: key);
    }

    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (sheetContext) {
          final loading = BoolStateRef();
          final controller = TextEditingController();
          return Column(
            children: [
              GPActionBottomSheetTitle(
                  loading: loading,
                  onCancel: () {
                    sheetContext.navigateBack();
                  },
                  onConfirm: () {
                    if (controller.text.isBlank) {
                      showToast(S.current.msg_error_input_device_key);
                      return;
                    }
                    sheetContext.uiTask
                        .options(UITaskOption(loadingRef: loading))
                        .run(save(controller.text))
                        .onSuccess((result) {
                      showToast(S.current.msg_success_add);
                      sheetContext.navigateBack();
                    });
                  },
                  title: S.current.bind_device),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(S.current.password),
                    const SizedBox(width: 8),
                    Expanded(
                        child: TextField(
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration.collapsed(
                          hintText: S.current.hint_input_device_password),
                      keyboardType: TextInputType.visiblePassword,
                      controller: controller,
                    ))
                  ],
                ),
              ),
              const GPDivider(),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final scanList = scanMap.values.toList();
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(S.current.scan_device),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          StreamBuilder(
              stream: FlutterBluePlus.isScanning,
              builder: (_, snapshot) => _SearchHeader(
                  isScan: snapshot.data ?? false, onSearch: startScan)),
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
            child: Text(
              S.current.scan_device,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
          Expanded(
            child: ListView.separated(
                itemCount: scanList.length,
                separatorBuilder: (_, index) => const GPDivider(),
                itemBuilder: (_, index) {
                  final item = scanList[index];
                  return _BluetoothDeviceItem(
                      scanResult: scanList[index],
                      onConnectClick: () {
                        connect(item);
                      });
                }),
          )
        ],
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  final bool isScan;
  final VoidCallback onSearch;

  const _SearchHeader(
      {required this.isScan, required this.onSearch, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            isScan
                ? S.current.searching_device
                : S.current.search_device_complete,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          if (isScan) const SizedBox(height: 8),
          Visibility(
            visible: isScan,
            child: Text(
              S.current.tip_searching_device,
              style: TextStyle(color: context.onSurfaceVariant),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const GPAssetImageWidget(
            "ic_bluetooth.png",
            height: 70,
          ),
          const SizedBox(
            height: 12,
          ),
          isScan
              ? Lottie.asset(
                  'public/waiting.json',
                )
              : GPFilledButton(
                  text: S.current.reset_search, onPressed: onSearch)
        ],
      ),
    );
  }
}

class _BluetoothDeviceItem extends StatelessWidget {
  final ScanResult scanResult;
  final VoidCallback onConnectClick;

  const _BluetoothDeviceItem(
      {required this.scanResult, required this.onConnectClick, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
              child: Text(scanResult.advertisementData.advName.isEmpty
                  ? scanResult.device.remoteId.str
                  : scanResult.advertisementData.advName)),
          SizedBox(
              height: 30,
              child: GPFilledButton(text:Intl.message("connect"), onPressed: onConnectClick))
        ],
      ),
    );
  }
}
