part of 'household_device_detail_screen.dart';

class _DeviceReminderScreen extends StatefulWidget {
  final String address;

  const _DeviceReminderScreen({required this.address, super.key});

  @override
  State<_DeviceReminderScreen> createState() => _DeviceReminderScreenState();
}

class _DeviceReminderScreenState extends State<_DeviceReminderScreen>
    with AutomaticKeepAliveClientMixin {
  late final refreshDelegate =
      GPPageableRefreshDelegate<ChargeWarningReminderPO>(
          onRequest: refreshData, refreshKey: GlobalKey());
  bool isEdit = false;
  final Set<int> selectedIds = {};
  final BoolStateRef deleteLoading = BoolStateRef();

  Future refreshData(int page, int size) =>uiTask
          .run(findCase<HouseholdDeviceCase>()
              .getReminderList(address: widget.address, page: page, size: size))
          .onSuccess((result) {
        refreshDelegate.notifyRefreshSuccess(result, page, notifyUpdate: false);
        setState(() {});
      }).onFailure((error) {
        refreshDelegate.notifyRefreshFail(page);
      }).future;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshDelegate.beginRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(S.current.reminder),
        actions: [
          if (refreshDelegate.dataList.isNotEmpty)
            IconButton(
                onPressed: () {
                  setState(() {
                    isEdit = !isEdit;
                  });
                },
                icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GPPageableRefreshWidget(
                refreshDelegate: refreshDelegate,
                builder: (_, dataList) => LoadMoreListView(
                      padding: const EdgeInsets.all(12),
                      onLoadMore: refreshDelegate.onLoadMore,
                      separatorBuilder: (_, index) => const SizedBox(
                        height: 12,
                      ),
                      loadMoreStatus: refreshDelegate.loadMoreStatus,
                      itemCount: dataList.length,
                      itemBuilder: (_, index) => _ReminderItem(
                        dataList[index],
                        showCheck: isEdit,
                        isCheck:
                            isEdit && selectedIds.contains(dataList[index].id),
                        onCheckChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedIds.add(dataList[index].id!);
                            } else {
                              selectedIds.remove(dataList[index].id!);
                            }
                          });
                        },
                      ),
                    )),
          ),
          if (isEdit)
            Container(
              color: context.surfaceColor,
              child: Row(
                children: [
                  Checkbox(
                      value: isAllChecked,
                      onChanged: (value) {
                        changeAllSelected();
                      }),
                  Text(S.current.all_selected),
                  const Expanded(child: SizedBox()),
                  RefProvider(deleteLoading,
                      builder: (_, ref, child) => GPTextButton(
                          isLoading: ref.value ?? false,
                          icon: const Icon(Icons.delete),
                          text: S.current.delete,
                          onPressed: selectedIds.isNotEmpty ? delete : null))
                ],
              ),
            )
        ],
      ),
    );
  }

  void changeAllSelected() {
    setState(() {
      if (isAllChecked) {
        selectedIds.clear();
      } else {
        selectedIds.addAll(refreshDelegate.dataList.map((e) => e.id!));
      }
    });
  }

  void delete() {
   uiTask
        .options(UITaskOption(loadingRef: deleteLoading))
        .run(findCase<HouseholdDeviceCase>()
            .deleteReminderList(widget.address, selectedIds))
        .onSuccess((result) {
      refreshDelegate.beginRefresh();
      setState(() {
        isEdit = false;
        selectedIds.clear();
      });
    });
  }

  bool get isAllChecked =>
      selectedIds.length == refreshDelegate.dataList.length;

  @override
  bool get wantKeepAlive => true;
}

final _reminderDateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

class _ReminderItem extends StatelessWidget {
  final ChargeWarningReminderPO item;
  final bool showCheck;
  final bool isCheck;
  final Function(bool?) onCheckChanged;

  const _ReminderItem(this.item,
      {required this.showCheck,
      required this.isCheck,
      required this.onCheckChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    final timeArray = _reminderDateFormat
        .format(DateTime.fromMillisecondsSinceEpoch(item.time))
        .split(" ");
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: context.surfaceColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showCheck)
                SizedBox(
                  width: 12,
                  height: 12,
                  child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -4),
                      value: isCheck,
                      onChanged: onCheckChanged),
                ),
              if (showCheck)
                const SizedBox(
                  width: 12,
                ),
              Text(timeArray[0])
            ],
          ),
          const SizedBox(height: 12),
          const GPDivider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.current.time,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    timeArray[1],
                    style: TextStyle(
                        color: context.onSurfaceVariant, fontSize: 12),
                  )
                ],
              )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.current.reminder,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    _resolveChargeStatusCodeResource(item.statusCode),
                    style: TextStyle(color: context.warningColor, fontSize: 12),
                  )
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }
}

String _resolveChargeStatusCodeResource(int statusCode) {
  return switch (statusCode) {
    >= 0 && < 8 => S.current.charge_status_code_0,
    8 => S.current.charge_status_code_8,
    9 => S.current.charge_status_code_9,
    10 => S.current.charge_status_code_10,
    11 => S.current.charge_status_code_11,
    12 => S.current.charge_status_code_12,
    13 => S.current.charge_status_code_13,
    14 => S.current.charge_status_code_14,
    15 => S.current.charge_status_code_15,
    16 => S.current.charge_status_code_16,
    17 => S.current.charge_status_code_17,
    _ => S.current.charge_status_code_any(statusCode),
  };
}
