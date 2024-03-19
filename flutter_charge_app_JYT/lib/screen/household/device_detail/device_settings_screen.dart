part of 'household_device_detail_screen.dart';

class _DeviceSettingsScreen extends StatefulWidget {
  final String address;

  const _DeviceSettingsScreen({required this.address, super.key});

  @override
  State<_DeviceSettingsScreen> createState() => __DeviceSettingsScreenState();
}

class __DeviceSettingsScreenState extends State<_DeviceSettingsScreen>
    with AutomaticKeepAliveClientMixin, StateAutoDisposeOwner {
  HouseholdDeviceDetail? detail;
  ChargeDeviceGunPO gun = const ChargeDeviceGunPO();
  GPChargeSynchroData synchroData = const GPChargeSynchroData();

  @override
  void initState() {
    super.initState();
    findCase<HouseholdDeviceCase>()
        .watchDeviceGun(widget.address)
        .listen((event) {
      final current = gun;
      final result = event ?? const ChargeDeviceGunPO();
      if (current == result) {
        return;
      }
      if (current.id != result.id ||
          current.current != result.current ||
          current.miniCurrent != result.miniCurrent ||
          current.maxCurrent != result.maxCurrent) {
        if (current.id != result.id || current.current != result.current) {
          setState(() {
            gun = result;
          });
        } else {
          gun = result;
        }
      }
    }).bind(this);

    findCase<HouseholdDeviceCase>()
        .watchSynchroData(widget.address)
        .listen((event) {
      final current = event ?? const GPChargeSynchroData();
      if (synchroData == current) {
        return;
      }
      if (current.temperature1 != synchroData.temperature1 ||
          current.temperature1 != synchroData.temperature2) {
        setState(() {
          synchroData = current;
        });
      }
    }).bind(this);

    findCase<HouseholdDeviceCase>()
        .watchDeviceDetail(widget.address)
        .listen((event) {
      if (detail == null) {
        if (event != null) {
          setState(() {
            detail = event;
          });
        }
      } else {
        final current = detail;
        if (current != event &&
            (event == null ||
                (current != null &&
                    (current.totalPower != event.totalPower ||
                        current.sn != event.sn ||
                        current.hVersion != event.hVersion ||
                        current.sVersion != event.sVersion)))) {
          setState(() {
            detail = event;
          });
        }
      }
    }).bind(this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(S.current.settings),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (gun.id != null)
              _DeviceSettingsItem(
                iconName: "investing_and_banking.svg",
                label: S.current.charge_current,
                value: "${gun.current}A",
                showArrow: true,
                onClick: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (dialogContext) {
                        return _CurrentPicker(
                            futureBuilder: (value) =>
                                findCase<HouseholdDeviceCase>()
                                    .updateGunCurrent(widget.address, value),
                            minValue: gun.miniCurrent,
                            maxValue: gun.maxCurrent,
                            value: gun.current);
                      });
                },
              ),
            if (gun.id != null)
              const SizedBox(
                height: 8,
              ),
            _DeviceSettingsItem(
                iconName: "cog.svg",
                iconColor: context.primaryColor,
                label: S.current.temperature,
                value: "$temperatureValue ℃"),
            _DeviceSettingsItem(
                iconName: "eco_house.svg",
                label: S.current.total_electric_energy,
                value:
                    "${synchroData.connectorMain?.electricWork ?? "-"} kW·h"),
            const SizedBox(
              height: 8,
            ),
            _DeviceSettingsItem(
                iconName: "file_bookmark.svg",
                label: S.current.device_sn,
                value: detail?.sn ?? "-"),
            _DeviceSettingsItem(
                iconName: "file_bookmark.svg",
                label: S.current.hardware_version,
                value: detail?.hVersion ?? "-"),
            _DeviceSettingsItem(
                iconName: "file_bookmark.svg",
                label: S.current.software_version,
                value: detail?.sVersion ?? "-"),
            const SizedBox(
              height: 8,
            ),
            _DeviceSettingsItem(
              iconName: "eco_house.svg",
              label: S.current.remote_diagnosis,
              onClick: () {
                uiTask
                    .options(const UITaskOption(isShowLoading: true))
                    .run(findCase<HouseholdDeviceCase>()
                        .updateLog(widget.address))
                    .onSuccess((result) {
                  showToast(S.current.msg_success_upload);
                });
              },
            ),
            _DeviceSettingsItem(
              iconName: "eco_house.svg",
              label: S.current.reboot,
              onClick: () {
                uiTask.run(
                    findCase<HouseholdDeviceCase>().reboot(widget.address));
              },
            ),
            _DeviceSettingsItem(
              iconName: "eco_house.svg",
              label: S.current.unbind,
              onClick: unbind,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void unbind() async {
    final isSuccess = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          final BoolStateRef loading = BoolStateRef();
          return GPMessageDialog(
            message: S.current.msg_confirm_unbind,
            onConfirm: () {
              dialogContext.uiTask
                  .options(UITaskOption(loadingRef: loading))
                  .run(findCase<HouseholdDeviceCase>().unbind(widget.address))
                  .onSuccess((result) {
                showToast(S.current.success_operation);
                dialogContext.navigateBack(true);
              });
            },
            onCancel: () {
              dialogContext.navigateBack();
            },
          );
        });
    if (isSuccess == true && mounted) {
      context.navigateBack();
    }
  }

  String get temperatureValue {
    var count = 0;
    double value = 0;
    var t1 = getTemperatureValue(synchroData.temperature1);
    if (t1 != null) {
      count++;
      value += t1;
    }
    var t2 = getTemperatureValue(synchroData.temperature2);
    if (t2 != null) {
      count++;
      value += t2;
    }
    if (count == 0) {
      return "-";
    } else {
      return (value / count).toStringAsFixed(1);
    }
  }

  double? getTemperatureValue(String? temperature) {
    if (temperature == null || temperature.isEmpty || temperature == '-') {
      return null;
    }
    try {
      return double.parse(temperature);
    } catch (e) {
      return null;
    }
  }
}

class _DeviceSettingsItem extends StatelessWidget {
  final Color? iconColor;
  final String iconName;
  final String label;
  final String? value;
  final VoidCallback? onClick;
  final bool showArrow;

  const _DeviceSettingsItem(
      {this.iconColor,
      required this.iconName,
      required this.label,
      this.onClick,
      this.value,
      this.showArrow = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: context.surfaceColor,
      child: InkWell(
        onTap: onClick,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SvgMenuIcon(
                iconName: iconName,
                iconColor: iconColor,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(label),
              if (value != null)
                Expanded(
                    child: Text(
                  value ?? "",
                  textAlign: TextAlign.end,
                )),
              if (showArrow)
                const Icon(Icons.arrow_forward_ios_rounded, size: 15)
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int value;
  final Future Function(int current) futureBuilder;

  const _CurrentPicker(
      {required this.minValue,
      required this.maxValue,
      required this.value,
      required this.futureBuilder,
      super.key});

  @override
  State<_CurrentPicker> createState() => _CurrentPickerState();
}

class _CurrentPickerState extends State<_CurrentPicker> {
  late int currentValue;
  final BoolStateRef loading = BoolStateRef();

  @override
  void initState() {
    super.initState();
    currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GPActionBottomSheetTitle(
          loading: loading,
          title: S.current.charge_current,
          onConfirm: () {
            if (currentValue == widget.value) {
              Navigator.of(context).pop();
              return;
            }
            uiTask
                .options(UITaskOption(loadingRef: loading))
                .run(widget.futureBuilder(currentValue))
                .onSuccess((result) {
              Navigator.of(context).pop(result);
            });
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        ),
        NumberPicker(
            minValue: widget.minValue,
            maxValue: widget.maxValue,
            initValue: currentValue,
            onValueChanged: (value) {
              setState(() {
                currentValue = value;
              });
            })
      ],
    );
  }
}
