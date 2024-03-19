import 'dart:math';

import 'package:chargestation/component/component.dart';
import 'package:chargestation/domain/domain.dart';
import 'package:chargestation/generated/l10n.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:chargestation/infrastructure/utils/iterables.dart';
import 'package:chargestation/repository/data/vo.dart';
import 'package:d_chart/d_chart.dart';

import '../../design.dart';

class ChargeStatisticScreen extends StatefulWidget {
  const ChargeStatisticScreen({super.key});

  @override
  State<ChargeStatisticScreen> createState() => _ChargeStatisticState();
}

enum _ChargeStatisticDateType { week, month }

class _ChargeStatisticState extends State<ChargeStatisticScreen> {
  _ChargeStatisticDateType type = _ChargeStatisticDateType.week;
  int updateVersion = 1;
  ChargeStatisticsVO? totalStatisticsVO;
  late List<OrdinalData> dataList = const [];

  @override
  void initState() {
    super.initState();
    findCase<HouseholdDeviceCase>().getChargeStatistics().then((value) {
      if (mounted) {
        setState(() {
          totalStatisticsVO = value;
        });
      }
    }).catchError((t) {});

    loadWeekData();
  }

  void loadWeekData() {
    final map = <String, DateTime>{};
    final now = DateTime.now();
    final zeroNow = now.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
    DateTime dateTime;
    final dateFormat = DateFormat("yyyy-MM-dd");
    for (var index = 0; index < 6; index++) {
      dateTime = zeroNow.subtract(Duration(days: 6 - index));
      map[dateFormat.format(dateTime)] = dateTime;
    }
    map[dateFormat.format(now)] = now;

    type = _ChargeStatisticDateType.week;
    dataList = map.values
        .map((e) => OrdinalData(
            domain:
                "${e.month.toString().padLeft(2, "0")}-${e.day.toString().padLeft(2, "0")}",
            measure: 0))
        .toList();
    if (mounted) {
      setState(() {});
    }
    final currentVersion = ++updateVersion;
    findCase<HouseholdDeviceCase>()
        .getChartStatistics(
      map.values.first,
      now,
    )
        .then((value) {
      if (currentVersion == updateVersion && mounted) {
        final dataMap = value.associateBy((item) => item.date);
        ChargeStatisticsByDay? statistics;
        String key;
        List<OrdinalData> resultList = [];
        for (var entry in map.entries) {
          statistics = dataMap[entry.key];
          key =
              "${entry.value.month.toString().padLeft(2, "0")}-${entry.value.day.toString().padLeft(2, "0")}";
          if (statistics == null) {
            resultList.add(OrdinalData(domain: key, measure: 0));
          } else {
            resultList
                .add(OrdinalData(domain: key, measure: statistics.totalPower));
          }
        }
        setState(() {
          dataList = resultList;
        });
      }
    });
  }

  void loadMonthData() {
    final map = <String, DateTime>{};
    final now = DateTime.now();
    final totalDay = daysInMonth(now.year, now.month);
    DateTime dateTime;
    final dateFormat = DateFormat("yyyy-MM-dd");
    for (var day = 1; day <= totalDay; day++) {
      dateTime = DateTime(now.year, now.month, day);
      map[dateFormat.format(dateTime)] = dateTime;
    }
    type = _ChargeStatisticDateType.month;
    dataList = map.values
        .map((e) => OrdinalData(
            domain:
                "${e.month.toString().padLeft(2, "0")}-${e.day.toString().padLeft(2, "0")}",
            measure: 0))
        .toList();
    if (mounted) {
      setState(() {});
    }
    final currentVersion = ++updateVersion;
    findCase<HouseholdDeviceCase>()
        .getChartStatistics(
      map.values.first,
      now,
    )
        .then((value) {
      if (currentVersion == updateVersion && mounted) {
        final dataMap = value.associateBy((item) => item.date);
        ChargeStatisticsByDay? statistics;
        String key;
        List<OrdinalData> resultList = [];
        for (var entry in map.entries) {
          statistics = dataMap[entry.key];
          key =
              "${entry.value.month.toString().padLeft(2, "0")}-${entry.value.day.toString().padLeft(2, "0")}";
          if (statistics == null) {
            resultList.add(OrdinalData(domain: key, measure: 0));
          } else {
            resultList
                .add(OrdinalData(domain: key, measure: statistics.totalPower));
          }
        }
        setState(() {
          dataList = resultList;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const blueColors = [
      Color(0x7685a1ff),
      Color(0x76bbfbff),
    ];
    const orangeColors = [
      Color(0x76f7b199),
      Color(0x76fff1cd),
    ];
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(S.current.charging_statistics),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: _StatisticItem(
                  colors: blueColors,
                  title: S.current.total_charge,
                  value: totalStatisticsVO == null
                      ? "-"
                      : totalStatisticsVO?.totalPower
                              .toStringAsPrecision(4)
                              .toString() ??
                          "",
                  unit: "kw/h",
                  iconName: "ic_total_charged.png",
                )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: _StatisticItem(
                  colors: orangeColors,
                  title: S.current.total_charge_time,
                  value: cumulativeTimeText,
                  unit: S.current.minute,
                  iconName: "ic_total_charged_time.png",
                )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: _StatisticItem(
                  colors: blueColors,
                  title: S.current.total_charge_times,
                  value: totalStatisticsVO == null
                      ? "-"
                      : totalStatisticsVO?.chargeTimes.toString() ?? "",
                  unit: S.current.times,
                  iconName: "ic_total_charged_times.png",
                ))
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      chartButton(
                          isSelected: type == _ChargeStatisticDateType.week,
                          text: S.current.week,
                          onClick: () {
                            loadWeekData();
                          }),
                      const SizedBox(
                        width: 8,
                      ),
                      chartButton(
                          isSelected: type == _ChargeStatisticDateType.month,
                          text: S.current.month,
                          onClick: () {
                            loadMonthData();
                          }),
                    ],
                  ),
                  _ChargeStatisticChart(
                    dataSize: min(dataList.length, 8),
                    startingDomain: "",
                    allowSliding: true,
                    dataList: dataList,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String get cumulativeTimeText {
    final value = totalStatisticsVO?.cumulativeTime;
    if (value == null) {
      return "-";
    }
    final duration = Duration(seconds: value);
    int minute = duration.inMinutes % 60;
    int second = duration.inSeconds % 60;
    if (second == 0) {
      return minute.toString();
    }
    return (minute + (1.0 * second / 60)).toStringAsFixed(1).toString();
  }

  Widget chartButton(
      {required bool isSelected,
      required String text,
      required VoidCallback onClick}) {
    return OutlinedButton(
        style: ButtonStyle(
          visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity),
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
          foregroundColor: MaterialStateProperty.all(
              isSelected ? context.primaryColor : context.outlineColor),
          side: MaterialStateProperty.all(
            BorderSide(
              color: isSelected ? context.primaryColor : context.outlineColor,
            ),
          ),
        ),
        onPressed: onClick,
        child: Text(text));
  }
}

class _StatisticItem extends StatelessWidget {
  final List<Color> colors;
  final String title;
  final String value;
  final String unit;
  final String iconName;

  const _StatisticItem(
      {super.key,
      required this.colors,
      required this.title,
      required this.value,
      required this.unit,
      required this.iconName});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
                //渐变位置
                begin: Alignment.topLeft, //右上
                end: Alignment.bottomRight, //左下
                stops: const [0.0, 1.0], //[渐变起始点, 渐变结束点]
                //渐变颜色[始点颜色, 结束颜色]
                colors: colors)),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: context.onSurfaceVariant),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(value),
            const SizedBox(
              height: 4,
            ),
            Text(unit),
            const SizedBox(
              height: 4,
            ),
            GPAssetImageWidget(
              iconName,
              width: c.maxWidth * 0.6,
              height: c.maxWidth * 0.6,
            )
          ],
        ),
      );
    });
  }
}

class _ChargeStatisticChart extends StatelessWidget {
  final int dataSize;
  final String startingDomain;
  final List<OrdinalData> dataList;
  final bool allowSliding;

  const _ChargeStatisticChart(
      {super.key,
      required this.dataSize,
      required this.startingDomain,
      required this.allowSliding,
      required this.dataList});

  @override
  Widget build(BuildContext context) {
    //return Placeholder();
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: DChartBarO(
        measureAxis: MeasureAxis(
          showLine: true,

          lineStyle: LineStyle(color: context.onSurface),
          labelStyle: LabelStyle(color: context.onSurface),
        ),
        barLabelValue: (group, data, index) =>
            data.measure == 0 ? "" : data.measure.toStringAsFixed(2),
        outsideBarLabelStyle: (group, data, index) =>
            LabelStyle(color: context.onSurface),
        barLabelDecorator:
            BarLabelDecorator(labelAnchor: BarLabelAnchor.middle),
        domainAxis: DomainAxis(
          lineStyle: LineStyle(color: context.onSurface),
          labelStyle: LabelStyle(
            color: context.onSurface,
          ),
          ordinalViewport: OrdinalViewport('', dataSize),
        ),
        allowSliding: allowSliding,
        groupList: [
          OrdinalGroup(id: '1', color: context.primaryColor, data: dataList),
        ],
      ),
    );
  }
}
