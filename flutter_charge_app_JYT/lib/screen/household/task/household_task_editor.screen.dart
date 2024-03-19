import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/domain/domain.dart';
import 'package:chargestation/infrastructure/dispose.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:chargestation/infrastructure/utils/string_extension.dart';
import 'package:collection/collection.dart';

class HouseHoldTaskEditorScreen extends StatefulWidget {
  final int? id;

  const HouseHoldTaskEditorScreen({this.id, super.key});

  @override
  State<HouseHoldTaskEditorScreen> createState() =>
      _HouseHoldTaskEditorScreenState();
}

class _HouseHoldTaskEditorScreenState extends State<HouseHoldTaskEditorScreen> {
  _ChargeEditorDTO editorDTO = _ChargeEditorDTO();
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  ChargeDeviceGunPO? mGun;
  final BoolStateRef commitLoading = BoolStateRef();

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      Future(() async {
        final timePO =
            await findCase<HouseholdDeviceCase>().getTimeById(widget.id!);
        ChargeDeviceGunPO? gun;
        if (timePO != null) {
          gun = await findCase<HouseholdDeviceCase>()
              .getChargeGunById(timePO.deviceId);
        }
        if (mounted && timePO != null) {
          setState(() {
            mGun = gun;
            editorDTO = _ChargeEditorDTO.fromDB(timePO);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(
            widget.id == null ? S.current.add_task : S.current.update_task),
        actions: [
          RefProvider(commitLoading,
              builder: (_, ref, child) => GPTextButton(
                  text: S.current.save,
                  isLoading: ref.value ?? false,
                  onPressed: commit))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _TaskEditorItem(
              iconName: "multiple.svg",
              name: S.current.charging_pile,
              showArrow: true,
              onClick: pickDevice,
              child: Expanded(
                child: Text(
                  editorDTO.deviceName,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            if (mGun != null)
              _TaskEditorItem(
                  iconName: "multiple.svg",
                  name: S.current.charge_current,
                  showArrow: true,
                  onClick: pickCurrent,
                  child: Expanded(
                    child: Text(
                      "${editorDTO.current} A",
                      textAlign: TextAlign.right,
                    ),
                  )),
            const SizedBox(
              height: 12,
            ),
            _TaskEditorItem(
              iconName: "multiple.svg",
              name: S.current.task_name,
              showArrow: true,
              onClick: pickName,
              onClearClick: () {
                setState(() {
                  editorDTO.taskName = "";
                });
              },
              showClear: editorDTO.taskName.isNotEmpty,
              child: Expanded(
                child: Text(
                  editorDTO.taskName,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            _TaskEditorItem(
              iconName: "calenda_jump_to_date.svg",
              name: S.current.start_date,
              showArrow: true,
              onClick: pickStartDate,
              onClearClick: () {
                setState(() {
                  editorDTO.startDate = null;
                });
              },
              showClear: editorDTO.startDate != null,
              child: Expanded(
                child: Text(
                  editorDTO.startDate == null
                      ? ""
                      : dateFormat.format(editorDTO.startDate!),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            _TaskEditorItem(
              iconName: "calenda_jump_to_date2.svg",
              name: S.current.end_date,
              showArrow: true,
              onClick: pickEndDate,
              onClearClick: () {
                setState(() {
                  editorDTO.endDate = null;
                });
              },
              showClear: editorDTO.endDate != null,
              child: Expanded(
                child: Text(
                  editorDTO.endDate == null
                      ? ""
                      : dateFormat.format(editorDTO.endDate!),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            _TaskEditorItem(
              iconName: "discussion_converstion.svg",
              name: S.current.loop_date,
              showArrow: true,
              onClick: () {
                pickLoop();
              },
              onClearClick: () {
                setState(() {
                  editorDTO.loop = "";
                });
              },
              showClear: editorDTO.loop.isNotEmpty,
              child: Expanded(
                child: Text(
                  formatLoop,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            _TaskEditorItem(
              iconName: "circle_clock.svg",
              name: S.current.start_time,
              showArrow: true,
              onClick: pickStartTime,
              child: Expanded(
                child: Text(
                  formatTime(editorDTO.startTime),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            _TaskEditorItem(
              iconName: "circle_clock.svg",
              name: S.current.end_time,
              showArrow: true,
              onClick: pickEndTime,
              child: Expanded(
                child: Text(
                  formatEndTime,
                  textAlign: TextAlign.right,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void commit() {
    if (editorDTO.deviceId <= 0) {
      showToast(S.current.msg_charge_device_not_selected);
      return;
    }
    if (editorDTO.taskName.isBlank) {
      showToast(S.current.msg_not_input_task_name);
      return;
    }
    if (editorDTO.startTime == null) {
      showToast(S.current.msg_start_time_not_selected);
      return;
    }
    if (editorDTO.endTime == null) {
      showToast(S.current.msg_end_time_not_selected);
      return;
    }
    if (editorDTO.startDate != null || editorDTO.endDate != null) {
      if (editorDTO.startDate == null) {
        showToast(S.current.msg_not_start_date);
        return;
      }
      if (editorDTO.endDate == null) {
        showToast(S.current.msg_not_end_date);
        return;
      }
    }

    uiTask
        .options(UITaskOption(loadingRef: commitLoading))
        .run(findCase<HouseholdDeviceCase>()
            .insertOrUpdateTimer(editorDTO.toPO()))
        .onSuccess((result) {
      showToast(S.current.success_update);
      context.navigateBack();
    });
  }

  void pickDevice() async {
    final result = await showModalBottomSheet<HouseholdDeviceItemVO>(
        context: context,
        builder: (_) => _DevicePicker(selectedId: editorDTO.deviceId));
    if (result != null) {
      final gun =
          await findCase<HouseholdDeviceCase>().getChargeGunById(result.id!);
      if (gun != null && mounted) {
        setState(() {
          mGun = gun;
          editorDTO.deviceId = result.id!;
          editorDTO.deviceName = result.name;
          editorDTO.deviceAddress = result.address;
          editorDTO.current = gun.current;
        });
      }
    }
  }

  void pickCurrent() async {
    final gun = mGun;
    if (gun == null) {
      return;
    }
    final result = await showModalBottomSheet<int>(
        context: context,
        builder: (_) => _CurrentPicker(
            minValue: gun.miniCurrent,
            maxValue: gun.maxCurrent,
            value: editorDTO.current));
    if (result != null && mounted) {
      setState(() {
        editorDTO.current = result;
      });
    }
  }

  void pickName() async {
    final result = await showModalBottomSheet<String>(
        context: context,
        builder: (_) => _NameEditor(name: editorDTO.taskName));
    if (result != null && mounted) {
      setState(() {
        editorDTO.taskName = result;
      });
    }
  }

  void pickTime(
      {required DateTime initialDate,
      required DateTime firstDate,
      required DateTime lastDate,
      required Function(DateTime dateTime) onConfirm}) async {
    final result = await showDialog<DateTime?>(
        context: context,
        builder: (dialogContext) => DatePickerDialog(
              firstDate: firstDate,
              lastDate: lastDate,
              initialDate: initialDate,
            ));
    if (result != null) {
      onConfirm(result);
    }
  }

  void pickStartDate() async {
    final firstDate = DateTime.now();
    final currentEndDate = editorDTO.endDate ?? DateTime(2100, 12, 31);
    final startDate = editorDTO.startDate ?? DateTime.now();
    final result = await showDialog<DateTime?>(
        context: context,
        builder: (dialogContext) => DatePickerDialog(
              firstDate: firstDate,
              lastDate: currentEndDate,
              initialDate: startDate.isAfter(firstDate) ? startDate : firstDate,
            ));
    if (result != null) {
      setState(() {
        editorDTO.startDate = result.copyWith(
            hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
        ;
      });
    }
  }

  void pickEndDate() async {
    final currentStartDate = editorDTO.startDate ?? DateTime.now();
    final endDate = editorDTO.endDate ?? DateTime.now();
    final result = await showDialog<DateTime?>(
        context: context,
        builder: (dialogContext) => DatePickerDialog(
              firstDate: currentStartDate,
              lastDate: DateTime(2100, 12, 31),
              initialDate: endDate.isAfter(currentStartDate)
                  ? endDate
                  : currentStartDate,
            ));
    if (result != null) {
      setState(() {
        editorDTO.endDate = result.copyWith(
            hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      });
    }
  }

  void pickStartTime() async {
    final currentStartTime = editorDTO.startTime ?? nowTime();
    final result = await showModalBottomSheet<Duration>(
        context: context,
        builder: (_) => _TimerPickerSheet(
              time: currentStartTime,
              title: S.current.start_time,
            ));
    if (result != null && mounted) {
      setState(() {
        editorDTO.startTime = result;
      });
    }
  }

  Duration nowTime() {
    final dateTime = DateTime.now();
    return Duration(
        hours: dateTime.hour,
        minutes: dateTime.minute,
        seconds: dateTime.second,
        milliseconds: dateTime.millisecond,
        microseconds: dateTime.microsecond);
  }

  void pickEndTime() async {
    final currentEndTime = editorDTO.endTime ?? nowTime();
    final result = await showModalBottomSheet<Duration>(
        context: context,
        builder: (_) => _TimerPickerSheet(
              time: currentEndTime,
              title: S.current.end_time,
            ));

    if (result != null && mounted) {
      setState(() {
        editorDTO.endTime = result;
      });
    }
  }

  void pickLoop() async {
    final result = await showModalBottomSheet<String>(
        context: context,
        builder: (_) => _LoopPicker(
              loop: editorDTO.loop,
            ));
    if (result != null && mounted) {
      setState(() {
        editorDTO.loop = result;
      });
    }
  }

  String get formatLoop {
    final loop = editorDTO.loop;
    if (loop.isEmpty) {
      return "";
    }
    if (loop == '1,2,3,4,5,6,7' || loop == "8") {
      return S.current.every_day;
    }
    final weeks = [
      S.current.monday,
      S.current.tuesday,
      S.current.wednesday,
      S.current.thursday,
      S.current.friday,
      S.current.saturday,
      S.current.sunday
    ];
    return loop
        .split(",")
        .where((value) => value.isNotEmpty)
        .map((e) => weeks[int.parse(e) - 1])
        .join(",");
  }

  String formatTime(Duration? time) {
    if (time == null) {
      return "";
    } else {
      return "${(time.inHours % 24).toString().padLeft(2, '0')}:${(time.inMinutes % 60).toString().padLeft(2, '0')}:${(time.inSeconds % 60).toString().padLeft(2, '0')}";
    }
  }

  String get formatEndTime {
    final endTime = editorDTO.endTime;
    if (endTime == null) {
      return "";
    }
    final startTime = editorDTO.startTime;
    if (startTime == null) {
      return formatTime(endTime);
    }
    if (startTime > endTime) {
      return "${S.current.next_day} ${formatTime(endTime)}";
    } else {
      return formatTime(endTime);
    }
  }
}

int _timeToSecond(DateTime dateTime) {
  return dateTime.hour * 60 * 60 + dateTime.minute * 60 + dateTime.second;
}

class _TimerPickerSheet extends StatefulWidget {
  final Duration time;
  final String title;

  const _TimerPickerSheet({required this.time, required this.title, super.key});

  @override
  State<_TimerPickerSheet> createState() => _TimerPickerSheetState();
}

class _TimerPickerSheetState extends State<_TimerPickerSheet> {
  late int hour;

  late int minute;

  late int second;

  @override
  void initState() {
    super.initState();
    hour = widget.time.inHours % 24;
    minute = widget.time.inMinutes % 60;
    second = widget.time.inSeconds % 60;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GPActionBottomSheetTitle(
            onCancel: () {
              context.navigateBack(null);
            },
            onConfirm: () {
              context.navigateBack(
                  Duration(hours: hour, minutes: minute, seconds: second));
            },
            title: widget.title),
        TimerPicker(
            hour: hour,
            minute: minute,
            second: second,
            onValueChanged: (h, m, s) {
              setState(() {
                hour = h;
                minute = m;
                second = s;
              });
            })
      ],
    );
  }
}

class _ChargeEditorDTO {
  int? id;
  String taskName = "";
  int deviceId = 0;
  String deviceAddress = "";
  DateTime? startDate;

  DateTime? endDate;

  String deviceName = "";
  Duration? startTime;

  Duration? endTime;

  int current = -1;
  String loop = "";
  int reminder = 0;
  String uniqueNo = "";
  int connectorId = 1;
  int version = 0;

  _ChargeEditorDTO();

  factory _ChargeEditorDTO.fromDB(ChargeTimeTaskPO timePO) => _ChargeEditorDTO()
    ..id = timePO.id
    ..taskName = timePO.taskName
    ..deviceId = timePO.deviceId
    ..deviceAddress = timePO.deviceAddress
    ..startDate = timePO.startDate == -1
        ? null
        : DateTime.fromMillisecondsSinceEpoch(timePO.startDate)
    ..endDate = timePO.endDate == -1
        ? null
        : DateTime.fromMillisecondsSinceEpoch(timePO.endDate)
    ..deviceName = timePO.deviceName
    ..startTime =
        timePO.startTime == -1 ? null : Duration(seconds: timePO.startTime)
    ..endTime = timePO.endTime == -1 ? null : Duration(seconds: timePO.endTime)
    ..current = timePO.current
    ..loop = timePO.loop
    ..reminder = timePO.reminder
    ..uniqueNo = timePO.uniqueNo
    ..connectorId = timePO.connectorId
    ..version = timePO.version;

  ChargeTimeTaskPO toPO() => ChargeTimeTaskPO()
    ..id = id
    ..taskName = taskName
    ..deviceId = deviceId
    ..deviceAddress = deviceAddress
    ..startDate = startDate?.millisecondsSinceEpoch ?? -1
    ..endDate = endDate?.millisecondsSinceEpoch ?? -1
    ..deviceName = deviceName
    ..startTime = startTime?.inSeconds ?? -1
    ..endTime = endTime?.inSeconds ?? -1
    ..current = current
    ..loop = loop
    ..reminder = reminder
    ..connectorId = connectorId
    ..version = version;
}

class _TaskEditorItem extends StatelessWidget {
  final String iconName;
  final String name;
  final Widget child;
  final bool showArrow;
  final VoidCallback? onClick;
  final VoidCallback? onClearClick;
  final bool showClear;

  const _TaskEditorItem(
      {required this.iconName,
      required this.name,
      required this.child,
      required this.showArrow,
      this.showClear = false,
      this.onClick,
      this.onClearClick,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SvgMenuIcon(
                iconName: iconName,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(name),
              child,
              if (showClear)
                SizedBox(
                  height: 20,
                  child: IconButton(
                      padding: const EdgeInsets.all(0),
                      visualDensity: const VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity),
                      onPressed: onClearClick,
                      icon: const Icon(
                        Icons.clear,
                        size: 15,
                      )),
                ),
              if (showArrow) const Icon(Icons.keyboard_arrow_right_sharp)
            ],
          ),
        ),
      ),
    );
  }
}

class _LoopPicker extends StatefulWidget {
  final String loop;

  const _LoopPicker({required this.loop, super.key});

  @override
  State<_LoopPicker> createState() => _LoopPickerState();
}

class _LoopPickerState extends State<_LoopPicker> {
  final loops = <int>[0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    super.initState();
    if (widget.loop.isNotEmpty) {
      final String nowLoop;
      if (widget.loop == "8") {
        nowLoop = "1,2,3,4,5,6,7";
      } else {
        nowLoop = widget.loop;
      }
      nowLoop.split(",").map((e) => int.parse(e)).forEach((element) {
        loops[element - 1] = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final weeks = [
      S.current.monday,
      S.current.tuesday,
      S.current.wednesday,
      S.current.thursday,
      S.current.friday,
      S.current.saturday,
      S.current.sunday
    ];
    final selectedTextStyle = TextStyle(color: context.primaryColor);
    return Column(
      children: [
        GPActionBottomSheetTitle(
            onCancel: () {
              context.navigateBack();
            },
            onConfirm: () {
              final result = [];
              for (var index = 0; index < loops.length; index++) {
                if (loops[index] == 1) {
                  result.add(index + 1);
                }
              }
              context.navigateBack(result.join(","));
            },
            title: S.current.loop_date),
        SizedBox(
          height: 300,
          child: ListView(
            children: weeks
                .mapIndexed((index, element) => Ink(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            loops[index] = loops[index] == 1 ? 0 : 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            element,
                            style: loops[index] == 1 ? selectedTextStyle : null,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}

class _DevicePicker extends StatefulWidget {
  final int? selectedId;

  const _DevicePicker({required this.selectedId, super.key});

  @override
  State<_DevicePicker> createState() => _DevicePickerState();
}

class _DevicePickerState extends State<_DevicePicker>
    with StateAutoDisposeOwner {
  int? selectedId;
  int selectedIndex = -1;
  List<HouseholdDeviceItemVO> deviceList = const [];

  @override
  void initState() {
    super.initState();
    selectedId = widget.selectedId;
    findCase<HouseholdDeviceCase>()
        .watchDeviceList(DeviceType.bluetooth)
        .listen((event) {
      setState(() {
        deviceList = event;
        selectedIndex = -1;
        for (var index = 0; index < event.length; index++) {
          if (event[index].id == selectedId) {
            selectedIndex = index;
            break;
          }
        }
      });
    }).bind(this);
  }

  @override
  Widget build(BuildContext context) {
    final selectedTextStyle = TextStyle(color: context.primaryColor);
    return Column(
      children: [
        GPActionBottomSheetTitle(
            onCancel: () {
              context.navigateBack();
            },
            onConfirm: () {
              if (selectedIndex != -1) {
                context.navigateBack(deviceList[selectedIndex]);
              }
            },
            title: S.current.loop_date),
        SizedBox(
          height: 300,
          child: ListView(
            children: deviceList
                .mapIndexed((index, element) => Ink(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            selectedId = element.id;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            element.name,
                            style: selectedIndex == index
                                ? selectedTextStyle
                                : null,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}

class _CurrentPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int value;

  const _CurrentPicker(
      {required this.minValue,
      required this.maxValue,
      required this.value,
      super.key});

  @override
  State<_CurrentPicker> createState() => _CurrentPickerState();
}

class _CurrentPickerState extends State<_CurrentPicker> {
  late int currentValue;

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
          title: S.current.charge_current,
          onConfirm: () {
            if (currentValue == widget.value) {
              Navigator.of(context).pop();
              return;
            }
            Navigator.of(context).pop(currentValue);
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

class _NameEditor extends StatefulWidget {
  final String name;

  const _NameEditor({required this.name, super.key});

  @override
  State<_NameEditor> createState() => _NameEditorState();
}

class _NameEditorState extends State<_NameEditor> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GPActionBottomSheetTitle(
          title: S.current.task_name,
          onConfirm: () {
            if (controller.text.isBlank) {
              return;
            }
            final current = controller.text;
            if (current != widget.name) {
              context.navigateBack(current);
            } else {
              context.navigateBack();
            }
          },
          onCancel: () {
            context.navigateBack();
          },
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(S.current.task_name),
              const SizedBox(width: 8),
              Expanded(
                  child: TextField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                    hintText: S.current.hint_input_task_name),
                controller: controller,
              ))
            ],
          ),
        ),
      ],
    );
  }
}
