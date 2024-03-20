import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/domain/domain.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';

class HouseholdTaskScreen extends StatefulWidget {
  const HouseholdTaskScreen({super.key});

  @override
  State<HouseholdTaskScreen> createState() => _HouseholdTaskScreenState();
}

class _HouseholdTaskScreenState extends State<HouseholdTaskScreen>
    with AutomaticKeepAliveClientMixin {
  late final refreshDelegate = GPPageableRefreshDelegate<ChargeRecordItemVO>(
      onRequest: refreshData, refreshKey: GlobalKey());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshDelegate.beginRefresh();
    });
  }

  Future refreshData(int page, int size) => context.uiTask
          .run(findCase<HouseholdDeviceCase>().getTimerTaskList(page, size))
          .onSuccess((result) {
        loggerFactory.getLogger("TaskScreen").debug(result);
        refreshDelegate.notifyRefreshSuccess(result, page);
      }).onFailure((error) {
        refreshDelegate.notifyRefreshFail(page);
      }).future;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final weeks = [
      S.current.monday,
      S.current.tuesday,
      S.current.wednesday,
      S.current.thursday,
      S.current.friday,
      S.current.saturday,
      S.current.sunday
    ];
    return GPScaffold(
      appBar: GPAppbar(
        automaticallyImplyLeading: false,
        title: GPAppBarTitle(S.current.task),
        actions: [
          IconButton(
            onPressed: () {
              gotoEditor();
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: GPPageableRefreshWidget(
          refreshDelegate: refreshDelegate,
          builder: (_, dataList) => LoadMoreListView(
                padding: const EdgeInsets.all(12),
                onLoadMore: refreshDelegate.onLoadMore,
                separatorBuilder: (_, index) => const SizedBox(
                  height: 12,
                ),
                loadMoreStatus: refreshDelegate.loadMoreStatus,
                itemCount: dataList.length,
                itemBuilder: (itemContext, index) {
                  final loading = BoolStateRef();
                  return _TimerItem(
                    switchLoading: loading,
                    dataList[index],
                    weeks: weeks,
                    onMoreClick: () {
                      openMoreAction(dataList[index]);
                    },
                    onOpenChanged: (val) {
                      final item = dataList[index];
                      itemContext.uiTask
                          .options(UITaskOption(loadingRef: loading))
                          .run(findCase<HouseholdDeviceCase>()
                              .openTimeTask(item.id!, val ?? false))
                          .onSuccess((result) {
                        if (result) {
                          for (var currentIndex = 0;
                              currentIndex < refreshDelegate.dataList.length;
                              currentIndex++) {
                            if (refreshDelegate.dataList[currentIndex].id ==
                                item.id) {
                              setState(() {
                                refreshDelegate.dataList[currentIndex] =
                                    item.copyWith(open: val == true ? 1 : 0);
                              });
                              break;
                            }
                          }
                        } else {
                          showToast(S.current.msg_error_request_fail);
                        }
                      });
                    },
                  );
                },
              )),
    );
  }

  void gotoEditor({int? id}) {
    context.navigateTo("/household/task/editor", arguments: {
      "id": id,
    });
  }

  void openMoreAction(ChargeRecordItemVO item) async {
    final action = await showModalBottomSheet(
        context: context, builder: (_) => _TaskBottomActionMenu(item));
    if (action != null && mounted) {
      if (action == _MoreActionType.delete) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (dialogContext) {
              final loading = BoolStateRef();
              return GPMessageDialog(
                message: S.current.tip_delete_time(item.taskName),
                onConfirm: () {
                  dialogContext.uiTask
                      .options(UITaskOption(loadingRef: loading))
                      .run(
                          findCase<HouseholdDeviceCase>().deleteTimer(item.id!))
                      .onSuccess((result) {
                    context.navigateBack();
                    refreshDelegate.beginRefresh();
                  });
                },
                onCancel: () {
                  dialogContext.navigateBack();
                },
              );
            });
      } else if (action == _MoreActionType.edit) {
        context
            .navigateTo("/household/task/editor", arguments: {"id": item.id});
      }
    }
  }

  @override
  bool get wantKeepAlive => true;
}

final _dateFormat = DateFormat("yyyy-MM-dd");

class _TimerItem extends StatelessWidget {
  final ChargeRecordItemVO item;
  final List<String> weeks;
  final Function(bool?) onOpenChanged;
  final VoidCallback onMoreClick;
  final BoolStateRef switchLoading;

  const _TimerItem(this.item,
      {required this.onOpenChanged,
      required this.weeks,
      required this.onMoreClick,
      required this.switchLoading,
      super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color: context.onSurfaceVariant, fontSize: 12);
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 5),
      decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                item.taskName,
                style: const TextStyle(fontWeight: FontWeight.w700),
              )),
              RefProvider(switchLoading, builder: (_, ref, child) {
                if (ref.value == true) {
                  return const GPLoadingWidget(
                    size: 30,
                  );
                }
                return SizedBox(
                  width: 30,
                  height: 30,
                  child: Transform.scale(
                      scale: 0.6,
                      child: Switch(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: item.open == 1,
                          onChanged: onOpenChanged)),
                );
              }),
              if (item.open == 0)
                IconButton(
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: onMoreClick,
                    icon: const Icon(Icons.more_horiz))
            ],
          ),
          Text(
            "${S.current.charging_pile}:${item.deviceName}",
            style: textStyle,
          ),
          Text(
            "${S.current.start_date}:${item.startDate == null ? "-" : _dateFormat.format(item.startDate!)}",
            style: textStyle,
          ),
          Text(
            "${S.current.end_date}:${item.endDate == null ? "-" : _dateFormat.format(item.endDate!)}",
            style: textStyle,
          ),
          Text(
            "${S.current.loop_date}:$formatLoop",
            style: textStyle,
          ),
          Text(
            "${S.current.start_time}:${formatTime(item.startTime)}",
            style: textStyle,
          ),
          Text(
            "${S.current.end_time}:${formatTime(item.endTime, isNextDay: (item.endTime != null && item.startTime != null && item.endTime!.inSeconds < item.startTime!.inSeconds))}",
            style: textStyle,
          )
        ],
      ),
    );
  }

  String get formatLoop {
    if (item.loop.isEmpty) {
      return "-";
    } else if (item.loop == "1,2,3,4,5,6,7" || item.loop == "8") {
      return S.current.every_day;
    } else {
      return item.loop
          .split(",")
          .where((value) => value.isNotEmpty)
          .map((e) => weeks[int.parse(e) - 1])
          .join(",");
    }
  }

  String formatTime(Duration? time, {bool isNextDay = false}) {
    if (time == null) {
      return "-";
    }
    final String timeText =
        "${(time.inHours % 24).toString().padLeft(2, "0")}:${(time.inMinutes % 60).toString().padLeft(2, "0")}:${(time.inSeconds % 60).toString().padLeft(2, "0")}";

    if (isNextDay) {
      return "${S.current.next_day} $timeText";
    }

    return timeText;
  }
}

class _TaskBottomActionMenu extends StatelessWidget {
  final ChargeRecordItemVO recordItemVO;

  const _TaskBottomActionMenu(this.recordItemVO, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(recordItemVO.taskName),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
          children: [
            _TaskBottomActionMenuItem(
              icon: const Icon(Icons.edit),
              name: S.current.edit,
              onClick: () {
                context.navigateBack(_MoreActionType.edit);
              },
            ),
            _TaskBottomActionMenuItem(
              icon: const Icon(Icons.delete),
              name: S.current.delete,
              onClick: () {
                context.navigateBack(_MoreActionType.delete);
              },
            ),
          ],
        )
      ],
    );
  }
}

enum _MoreActionType {
  edit,
  delete,
}

class _TaskBottomActionMenuItem extends StatelessWidget {
  final Widget icon;
  final String name;
  final VoidCallback onClick;

  const _TaskBottomActionMenuItem(
      {required this.icon,
      required this.name,
      required this.onClick,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: onClick,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              const SizedBox(
                height: 4,
              ),
              Text(name)
            ],
          ),
        ),
      ),
    );
  }
}
