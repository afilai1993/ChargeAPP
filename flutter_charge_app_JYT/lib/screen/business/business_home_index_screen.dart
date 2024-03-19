part of 'business_home_screen.dart';

enum _ChargeSort {
  price("price"),
  distance("distance");

  final String name;

  const _ChargeSort(this.name);
}

class HomeIndexScreen extends StatefulWidget {
  const HomeIndexScreen({super.key});

  @override
  State<HomeIndexScreen> createState() => _HomeIndexScreenState();
}

class _HomeIndexScreenState extends State<HomeIndexScreen>
    with AutomaticKeepAliveClientMixin {
  final sort = _ChargeSort.distance;

  late final refreshDelegate = GPPageableRefreshDelegate<ChargeStationItemDTO>(
      onRequest: refreshData, refreshKey: GlobalKey());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshDelegate.beginRefresh();
    });
  }

  Future refreshData(int page, int size) => context.uiTask
          .run(findCase<ChargeCase>().getChargeStationList(
              pageNum: page, pageSize: size, type: sort.name))
          .onSuccess((result) {
        refreshDelegate.notifyRefreshSuccess(result.data, page,
            total: result.total);
      }).onFailure((error) {
        refreshDelegate.notifyRefreshFail(page);
      }).future;

  // void refreshPage(int page, int size) {
  //   context.uiTask
  //       .options(const UITaskOption(isShowLoading: false))
  //       .run(findCase<ChargeCase>().getChargeStationList(
  //           pageNum: page, pageSize: size, type: sort.name))
  //       .onSuccess((result) {
  //     setState(() {
  //       refreshController.notifyRefreshSuccess(result.data, result.total, page);
  //     });
  //   }).onFailure((error) {
  //     refreshController.notifyRefreshFail(page);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GPScaffold(
        appBar: GPAppbar(
          title: GPAppBarTitle(S.current.app_name),
        ),
        body: Column(
          children: [
            _HomeSearchIndexBar(sort: sort),
            Expanded(
              child: GPPageableRefreshWidget(
                  refreshDelegate: refreshDelegate,
                  builder: (_, dataList) => LoadMoreListView(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        onLoadMore: refreshDelegate.onLoadMore,
                        loadMoreStatus: refreshDelegate.loadMoreStatus,
                        itemCount: dataList.length,
                        separatorBuilder: (_, index) => const SizedBox(
                          height: 8,
                        ),
                        itemBuilder: (_, index) =>
                            _ChargeStationItemWidget(dataList[index]),
                      )),
            )
          ],
        ));
  }

  void getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    final current = await Geolocator.getCurrentPosition();
    // print(current);
  }

  @override
  bool get wantKeepAlive => true;
}

class _HomeSearchIndexBar extends StatelessWidget {
  final _ChargeSort sort;

  const _HomeSearchIndexBar({required this.sort, super.key});

  @override
  Widget build(BuildContext context) {
    final String sortName;
    if (sort == _ChargeSort.distance) {
      sortName = S.current.distance_asc;
    } else {
      sortName = S.current.price_asc;
    }
    return Row(
      children: [GPTextButton(text: sortName, onPressed: () {})],
    );
  }
}

class _ChargeStationItemWidget extends StatelessWidget {
  final ChargeStationItemDTO item;

  const _ChargeStationItemWidget(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(item.name)),
                Text("Fast"),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
                "Gp Building, No. 608 Lingdou  West Road, Siming District, Xiamen City"),
            const SizedBox(
              height: 2,
            ),
            Row(
              children: [Expanded(child: Text("电价:￥12.00")), Text("距离:10km")],
            ),
            const SizedBox(
              height: 8,
            ),
            const GPDivider(),
            const SizedBox(
              height: 8,
            ),
            Wrap(
              spacing: 8,
              children: [
                _Label("toilet"),
                _Label("lounge"),
                _Label("DC120kw.h"),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
            color: context.onSurfaceVariant,
            width: 1,
            style: BorderStyle.solid),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Text(text),
    );
  }
}
