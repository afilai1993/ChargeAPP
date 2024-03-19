import 'dart:math';

import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/infrastructure/dispose.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../infrastructure/infrastructure.dart';
import 'status_page.dart';

enum GPLoadMoreStatus {
  idle,
  fail,
  noMore,
  refresh,
}

class GPPageableRefreshDelegate<T> with ChangeNotifier {
  final scrollController = ScrollController();
  final Future<void> Function(int page, int size) onRequest;
  final List<T> dataList = [];
  int currentPage = 1;
  final int pageSize;
  StatusPageType _pageType = StatusPageType.none;
  final GlobalKey<RefreshViewState>? refreshKey;
  var loadMoreStatus = GPLoadMoreStatus.idle;

  GPPageableRefreshDelegate({
    required this.onRequest,
    this.pageSize = 10,
    this.refreshKey,
  });

  StatusPageType get pageType => _pageType;

  void beginRefresh() {
    refreshKey?.currentState?.refresh();
  }

  void notifyRefreshSuccess(
    List<T> result,
    int page, {
    int? total,
    bool notifyUpdate = true,
  }) {
    if (page == 1) {
      dataList.clear();
      dataList.addAll(result);
      if (dataList.isEmpty) {
        _pageType = StatusPageType.empty;
      } else {
        _pageType = StatusPageType.success;
      }
      currentPage = 1;
      if (total != null) {
        loadMoreStatus = dataList.length >= total
            ? GPLoadMoreStatus.noMore
            : GPLoadMoreStatus.idle;
      } else {
        loadMoreStatus = result.length < pageSize
            ? GPLoadMoreStatus.noMore
            : GPLoadMoreStatus.idle;
      }
      if (notifyUpdate) {
        notifyListeners();
      }

      // controller.refreshSuccess(dataList.isEmpty,
      //     noMore: dataList.length >= total);
    } else {
      if (page != currentPage + 1) {
        return;
      }
      currentPage = page;
      dataList.addAll(result);
      if (total != null) {
        loadMoreStatus = dataList.length >= total
            ? GPLoadMoreStatus.noMore
            : GPLoadMoreStatus.idle;
      } else {
        loadMoreStatus = result.length < pageSize
            ? GPLoadMoreStatus.noMore
            : GPLoadMoreStatus.idle;
      }
      if (notifyUpdate) {
        notifyListeners();
      }
      //controller.loadMoreSuccess(dataList.length >= total);
    }
  }

  void notifyRefreshFail(int page) {
    if (page == 1) {
      if (_pageType != StatusPageType.success) {
        _pageType = StatusPageType.fail;
        notifyListeners();
      }
    } else {
      loadMoreStatus = GPLoadMoreStatus.fail;
      notifyListeners();
    }
  }

  Future onRefresh() {
    if (_pageType != StatusPageType.success &&
        _pageType != StatusPageType.refresh) {
      _pageType = StatusPageType.refresh;
      notifyListeners();
    }
    return onRequest(1, pageSize);
  }

  void onLoadMore() {
    loadMoreStatus = GPLoadMoreStatus.refresh;
    onRequest(currentPage + 1, pageSize);
    notifyListeners();
  }
}

class GPPageableRefreshWidget<T> extends StatelessWidget {
  final GPPageableRefreshDelegate<T> refreshDelegate;
  final Widget Function(BuildContext, List<T>) builder;

  const GPPageableRefreshWidget(
      {required this.refreshDelegate, required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    return RefProvider(
      refreshDelegate,
      builder: (_, ref, child) => GPRefreshView(
          key: refreshDelegate.refreshKey,
          pageType: refreshDelegate.pageType,
          onRefresh: refreshDelegate.onRefresh,
          builder: (_) => builder(context, ref.dataList)),
    );
  }
}

class LoadMoreController with ChangeNotifier {
  GPLoadMoreStatus _loadMoreStatus = GPLoadMoreStatus.idle;

  GPLoadMoreStatus get status => _loadMoreStatus;

  set status(GPLoadMoreStatus value) {
    if (status != value) {
      _loadMoreStatus = status;
      notifyListeners();
    }
  }
}

class LoadMoreListView extends StatefulWidget {
  final ScrollController? scrollController;
  final NullableIndexedWidgetBuilder itemBuilder;
  final int? itemCount;
  final bool enableLoadMore;
  final GPLoadMoreStatus loadMoreStatus;
  final Function() onLoadMore;
  final EdgeInsetsGeometry? padding;
  final IndexedWidgetBuilder? separatorBuilder;

  const LoadMoreListView(
      {this.scrollController,
      this.enableLoadMore = true,
      required this.itemBuilder,
      required this.itemCount,
      required this.loadMoreStatus,
      required this.onLoadMore,
      this.padding,
      this.separatorBuilder,
      super.key});

  @override
  State<LoadMoreListView> createState() => _LoadMoreListViewState();
}

class _LoadMoreListViewState extends State<LoadMoreListView>
    with StateAutoDisposeOwner {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = widget.scrollController ?? ScrollController();
    scrollController.addListenerInDispose(this, onScroll);
  }

  void onScroll() {
    if (scrollController.position.extentAfter <= 30) {
      if (widget.enableLoadMore &&
          widget.loadMoreStatus == GPLoadMoreStatus.idle) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = (widget.itemCount ?? 0) + (widget.enableLoadMore ? 1 : 0);
    final NullableIndexedWidgetBuilder itemBuilder;
    if (widget.enableLoadMore) {
      itemBuilder = (ctx, index) {
        if (index == itemCount - 1) {
          return _LoadMoreFooter(
            widget.loadMoreStatus,
            onRefresh: widget.onLoadMore,
          );
        } else {
          return widget.itemBuilder(ctx, index);
        }
      };
    } else {
      itemBuilder = widget.itemBuilder;
    }
    if (widget.separatorBuilder != null) {
      final IndexedWidgetBuilder innerSeparatedBuilder;
      if (widget.enableLoadMore) {
        innerSeparatedBuilder = (ctx, index) {
          if (index == itemCount - 1) {
            return const SizedBox();
          } else {
            return widget.separatorBuilder!(ctx, index);
          }
        };
      } else {
        innerSeparatedBuilder = widget.separatorBuilder!;
      }
      return ListView.separated(
          separatorBuilder: innerSeparatedBuilder,
          padding: widget.padding,
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          controller: scrollController,
          itemCount: itemCount,
          itemBuilder: itemBuilder);
    }

    return ListView.builder(
        padding: widget.padding,
        physics: const AlwaysScrollableScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        controller: scrollController,
        itemCount: itemCount,
        itemBuilder: itemBuilder);
  }
}

class GPRefreshView extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final AsyncCallback onRefresh;
  final StatusPageType pageType;

  @override
  State<GPRefreshView> createState() => RefreshViewState();

  const GPRefreshView({
    super.key,
    required this.pageType,
    required this.builder,
    required this.onRefresh,
  });
}

class RefreshViewState extends State<GPRefreshView> {
  final height = 90.0;
  final _refreshIndicatorKey = GlobalKey<CustomRefreshIndicatorState>();

  void refresh() {
    final currentPageType = widget.pageType;
    if (currentPageType != StatusPageType.success) {
      widget.onRefresh();
    } else {
      _refreshIndicatorKey.currentState?.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      Widget child;
      final pageType = widget.pageType;
      if (widget.pageType == StatusPageType.empty) {
        child = SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          child: GPEmptyStatusPage(
            height: constraints.maxHeight,
          ),
        );
      } else if (pageType == StatusPageType.fail) {
        child = GPFailStatusPage(
          onRefresh: refresh,
        );
      } else if (pageType == StatusPageType.refresh) {
        child = const GPRefreshStatusPage();
      } else if (pageType == StatusPageType.success) {
        child = widget.builder(context);
      } else {
        child = const SizedBox();
      }
      return CustomRefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: widget.onRefresh,
          trigger: IndicatorTrigger.leadingEdge,
          offsetToArmed: height,
          durations: const RefreshIndicatorDurations(
            completeDuration: Duration(milliseconds: 600),
          ),
          builder: (_, child, controller) => _RefreshHeader(
                controller: controller,
                height: height,
                body: child,
              ),
          child: child);
    });
  }
}

class _RefreshHeader extends StatelessWidget {
  final IndicatorController controller;
  final double height;
  final Widget body;

  const _RefreshHeader({
    super.key,
    required this.controller,
    required this.height,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final dy = min(controller.value * height, height);
          final String text;
          final Widget leftWidget;
          switch (controller.state) {
            case IndicatorState.idle:
            case IndicatorState.dragging:
            case IndicatorState.canceling:
              text = S.current.pull_down_refresh;
              leftWidget = const Icon(
                Icons.arrow_downward_outlined,
                size: 15,
              );
              break;
            case IndicatorState.armed:
            case IndicatorState.settling:
              text = S.current.pull_down_release;
              leftWidget = const Icon(
                Icons.arrow_upward_outlined,
                size: 15,
              );
              break;
            case IndicatorState.loading:
              text = S.current.loading;
              leftWidget = const GPLoadingWidget(
                size: 15,
              );
              break;
            case IndicatorState.complete:
            case IndicatorState.finalizing:
              text = S.current.loading_complete;
              leftWidget = const Icon(
                Icons.done,
                size: 15,
              );
              break;
          }

          return Stack(
            children: [
              Transform.translate(
                offset: Offset(0.0, dy),
                child: body,
              ),
              Positioned(
                top: -height,
                left: 0,
                right: 0,
                height: height,
                child: Container(
                  transform: Matrix4.translationValues(0.0, dy, 0.0),
                  constraints: const BoxConstraints.expand(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      leftWidget,
                      const SizedBox(
                        width: 8,
                      ),
                      Text(text)
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class _LoadMoreFooter extends StatelessWidget {
  final GPLoadMoreStatus status;
  final VoidCallback onRefresh;

  const _LoadMoreFooter(this.status, {required this.onRefresh, super.key});

  @override
  Widget build(BuildContext context) {
    final String text;
    if (status == GPLoadMoreStatus.fail) {
      text = S.current.load_more_refresh_error;
    } else if (status == GPLoadMoreStatus.noMore) {
      text = S.current.no_more;
    } else {
      //refresh
      text = S.current.loading;
    }
    final Widget child;
    if (status == GPLoadMoreStatus.fail) {
      child = GPTextButton(text: text, onPressed: onRefresh);
    } else {
      child = Text(text);
    }
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (status == GPLoadMoreStatus.refresh)
            const GPLoadingWidget(
              size: 15,
            ),
          if (status == GPLoadMoreStatus.refresh)
            const SizedBox(
              width: 8,
            ),
          child
        ],
      ),
    );
  }
}
