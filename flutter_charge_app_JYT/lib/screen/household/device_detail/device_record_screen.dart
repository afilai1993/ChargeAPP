part of 'household_device_detail_screen.dart';

class _DeviceRecordScreen extends StatefulWidget {
  final String address;

  const _DeviceRecordScreen({required this.address, super.key});

  @override
  State<_DeviceRecordScreen> createState() => _DeviceRecordScreenState();
}

class _DeviceRecordScreenState extends State<_DeviceRecordScreen>
    with AutomaticKeepAliveClientMixin {
  DateTime startDate = DateTime.now()
      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  DateTime endDate = DateTime.now().copyWith(hour: 23, minute: 59, second: 59);

  final DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateTime maxStartDate = DateTime(2023, 10, 12);
  DateTime maxEndDate = DateTime.now().copyWith(
      hour: 23, minute: 59, second: 59, millisecond: 0, microsecond: 0);
  late final refreshDelegate = GPPageableRefreshDelegate<ChargeRecordPO>(
      onRequest: refreshData, refreshKey: GlobalKey());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshDelegate.beginRefresh();
    });
  }

  Future refreshData(int page, int size) => uiTask.run(Future(() async {
        if (page == 1) {
          await findCase<HouseholdDeviceCase>()
              .requestRecordSync(widget.address);
        }
        return findCase<HouseholdDeviceCase>().getChargeRecordList(
            address: widget.address,
            page: page,
            size: size,
            startTime: startDate.millisecondsSinceEpoch,
            endTime: endDate.millisecondsSinceEpoch);
      })).onSuccess((result) {
        refreshDelegate.notifyRefreshSuccess(result, page);
      }).onFailure((error) {
        refreshDelegate.notifyRefreshFail(page);
      }).future;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(S.current.record),
      ),
      body: Column(
        children: [
          const GPDivider(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: _TimeItem(
                  label: S.current.start_date,
                  value: dateFormat.format(startDate),
                  onClick: () {
                    pickTime(
                        initialDate: startDate,
                        firstDate: maxStartDate,
                        lastDate: endDate,
                        onConfirm: (result) {
                          setState(() {
                            startDate = result.copyWith(
                                hour: 0,
                                minute: 0,
                                second: 0,
                                millisecond: 0,
                                microsecond: 0);
                          });
                        });
                  },
                ),
              ),
              Expanded(
                child: _TimeItem(
                  label: S.current.end_date,
                  value: dateFormat.format(endDate),
                  onClick: () {
                    pickTime(
                        initialDate: endDate,
                        firstDate: startDate,
                        lastDate: maxEndDate,
                        onConfirm: (result) {
                          setState(() {
                            endDate = result.copyWith(
                                hour: 23, minute: 59, second: 59);
                          });
                        });
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    refreshDelegate.beginRefresh();
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
          const GPDivider(),
          Expanded(
            child: GPPageableRefreshWidget(
                refreshDelegate: refreshDelegate,
                builder: (_, dataList) => LoadMoreListView(
                      separatorBuilder: (_, index) => const SizedBox(
                        height: 12,
                      ),
                      padding: const EdgeInsets.all(12),
                      onLoadMore: refreshDelegate.onLoadMore,
                      loadMoreStatus: refreshDelegate.loadMoreStatus,
                      itemCount: dataList.length,
                      itemBuilder: (_, index) =>
                          _ChargeRecordItem(dataList[index]),
                    )),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

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
}

class _TimeItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onClick;

  const _TimeItem(
      {required this.onClick,
      required this.label,
      required this.value,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(color: context.onSurfaceVariant),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}

final _recordDateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

class _ChargeRecordItem extends StatelessWidget {
  final ChargeRecordPO item;

  const _ChargeRecordItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: context.onSurfaceVariant);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: context.surfaceColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${S.current.charge_mode}:${item.stopReason}",
            style: textStyle,
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
              "${S.current.start_date}:${_recordDateFormat.format(DateTime.fromMillisecondsSinceEpoch(item.startTime))}",
              style: textStyle),
          const SizedBox(
            height: 2,
          ),
          Text(
              "${S.current.end_date}:${_recordDateFormat.format(DateTime.fromMillisecondsSinceEpoch(item.endTime))}",
              style: textStyle),
          const SizedBox(
            height: 2,
          ),
          Text("${S.current.charge_time}:${_formatTimeSize}", style: textStyle),
          const SizedBox(
            height: 2,
          ),
          Text("${S.current.charge_energy}:${item.energy}", style: textStyle),
        ],
      ),
    );
  }

  String get _formatTimeSize {
    final miSecond = item.endTime - item.startTime;
// 总秒数
    var second = miSecond ~/ 1000;
    // 天数
    var day = second / 3600 ~/ 24;
    // 小时
    var hr = (second / 3600 % 24).toInt();
    // 分钟
    var min = (second / 60 % 60).toInt();
    // 秒
    var sec = second % 60;
    if (day > 0) {
      return "${day}${S.current.day} ${hr.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
    } else {
      return "${hr.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
    }
  }
}
