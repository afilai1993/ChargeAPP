part of 'household_device_detail_screen.dart';

class _DeviceProfileScreen extends StatefulWidget {
  final String address;

  const _DeviceProfileScreen({required this.address, super.key});

  @override
  State<_DeviceProfileScreen> createState() => _DeviceProfileScreenState();
}

class _DeviceProfileScreenState extends State<_DeviceProfileScreen>
    with AutomaticKeepAliveClientMixin, StateAutoDisposeOwner {
  GPChargeSynchroData? synchroData;
  GPChargeSynchroStatus? synchroStatus;
  HouseholdChargeDeviceConnectState connectState =
      HouseholdChargeDeviceConnectState.idle;
  final BoolStateRef chargeLoading = BoolStateRef();
  HouseholdDeviceDetail? detail;

  static String _chargingTimeUpdate ="0:0:0";
  int count = 0;
  void _updateChargingTime() {
    // 模拟更新 _chargingTimeUpdate 的值
    setState(() {
      _chargingTimeUpdate;
      debugPrint('_chargingTimeUpdate:$_chargingTimeUpdate');
    });
  }
  // int timeToSeconds(String time) {
  //   List<String> parts = time.split(':');
  //   int hours = int.parse(parts[0]);
  //   int minutes = int.parse(parts[1]);
  //   int seconds = int.parse(parts[2]);
  //
  //   return hours * 3600 + minutes * 60 + seconds;
  // }
  int timeToSeconds(String time) {
    if(time=="-")
      {
        return 0;
      }
    else
      {
        List<String> parts = time.split(':');
        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);
        int seconds = int.parse(parts[2]);

        Duration duration = Duration(hours: hours, minutes: minutes, seconds: seconds);
        return duration.inSeconds;
      }

  }
  String secondsToTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    return '$hours:$minutes:$remainingSeconds';
  }
  void calculateChargingTime1() {
    // 计算充电时间
    // 返回新的_chargingTimeUpdate值

    Timer.periodic(const Duration(seconds: 1), (timer) async{
     int timeOld=timeToSeconds(_chargingTimeUpdate);
     int timeNow=timeToSeconds(chargingTime);
     final isCharge = synchroStatus?.connectorMain?.chargeStatus == 'charging';
     if(isCharge)
       {
         if(timeNow>timeOld)
           {
             _chargingTimeUpdate=chargingTime;

           }
         else
           {
             if(timeOld-timeNow<5)
               {
                 _chargingTimeUpdate=secondsToTime(timeOld+1);
               }
             else
               {
                 _chargingTimeUpdate=chargingTime;
               }

           }
       }
     else
       {
         _chargingTimeUpdate=chargingTime;
       }

     debugPrint('执行定时chargingTime任务');
      _updateChargingTime();

    });

  }




  @override
  void initState() {
    super.initState();
      // 在初始化时启动监听
    calculateChargingTime1();
    _chargingTimeUpdate=chargingTime;
    findCase<HouseholdDeviceCase>()
        .getDeviceDetail(widget.address)
        .then((value) {
      if (mounted) {
        setState(() {
          detail = value;
        });
      }
    });

    findCase<HouseholdDeviceCase>()
        .watchSynchroData(widget.address)
        .listen((event) {
      setState(() {
        synchroData = event;
      });
    }).bind(this);
    findCase<HouseholdDeviceCase>()
        .watchSynchroStatus(widget.address)
        .listen((event) {
      setState(() {
        synchroStatus = event;
      });
    }).bind(this);
    findCase<HouseholdDeviceCase>()
        .watchConnectState(widget.address)
        .listen((event) {
      setState(() {
        connectState = event;
      });
    }).bind(this);
  }

  String get connectText {
    switch (connectState) {
      case HouseholdChargeDeviceConnectState.idle:
        return S.current.connect;
      case HouseholdChargeDeviceConnectState.connecting:
        return S.current.connect_status_connecting;
      case HouseholdChargeDeviceConnectState.ensureKey:
        return S.current.connect_status_ensure_key;
      case HouseholdChargeDeviceConnectState.connected:
        return S.current.disconnect;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCharge = synchroStatus?.connectorMain?.chargeStatus == 'charging';

    super.build(context);
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(detail == null ? S.current.device : detail!.name),
        actions: [
          GPTextButton(
              text: connectText,
              onPressed:
                  (connectState == HouseholdChargeDeviceConnectState.idle ||
                          connectState ==
                              HouseholdChargeDeviceConnectState.connected)
                      ? () {
                          if (connectState ==
                              HouseholdChargeDeviceConnectState.idle) {
                            uiTask.run(findCase<HouseholdDeviceCase>()
                                .requestConnect(widget.address));
                          } else {
                            findCase<HouseholdDeviceCase>()
                                .disconnect(widget.address);
                          }
                        }
                      : null)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Battery(chargeStatus: synchroStatus?.connectorMain?.chargeStatus),
            Center(
              child: RefProvider(
                chargeLoading,
                builder: (_, ref, child) => _ChargeSwitch(
                  isLoading: ref.value ?? false,
                  isCharge: isCharge,
                  onClick: requestCharge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),//数据总览标签
              child: Text(S.current.data_profile),
            ),
            profileWidget(context)
          ],
        ),
      ),
    );
  }

  void requestCharge() {
    if (connectState != HouseholdChargeDeviceConnectState.connected) {
      showToast(S.current.msg_device_not_connected);
      return;
    }
    final chargeStatus = synchroStatus?.connectorMain?.chargeStatus;
    if (chargeStatus == null) {
      return;
    } else if (chargeStatus == "safeFault" || chargeStatus == "other") {
      showToast(S.current.msg_device_error);
    } else if ((chargeStatus == "charging" ||
            chargeStatus == "wait" ||
            chargeStatus == "finish") &&
        synchroStatus?.connectorMain?.connectionStatus == true) {

      uiTask
          .options(UITaskOption(loadingRef: chargeLoading))
          .run(findCase<HouseholdDeviceCase>()
              .requestCharge(widget.address, chargeStatus != "charging"))
          .onSuccess((result) {
        if (result) {
          showToast(S.current.request_success);
        } else {
          showToast(S.current.request_fail);
        }
      });
    } else {
      showToast(S.current.msg_insert_charging_gun);
    }
  }

  Widget profileWidget(BuildContext context) {
    final screenWidth = context.screenWidth;
    final largeSize = (screenWidth - 12 * 4) / 2;
    final smallSize = (largeSize) / 2;
    const blueColors = [
      Color(0x7685a1ff),
      Color(0x76bbfbff),
    ];
    const orangeColors = [
      Color(0x76f7b199),
      Color(0x76fff1cd),
    ];
    const greenColors = [
      Color(0x76f6ec7e),
      Color(0x767fc4be),
    ];

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          _DataProfileItem(
            label: "${S.current.total_electric_energy}(kW·h)",
            value: synchroData?.connectorMain?.electricWork ?? "-",
            width: largeSize,//总电量设置
            height: largeSize,
            colors: blueColors,
            icon: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                child: GPAssetImageWidget(
                  "ic_profile_total_power.png",
                  width: largeSize / 3 * 2,
                  height: largeSize / 3 * 2,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            children: [
              _SmallDataProfileItem(
                value: synchroData?.connectorMain?.current ?? "-",//电流显示部件
                label: S.current.profile_current,
                width: smallSize,
                height: smallSize - 12,
                colors: orangeColors,
                iconName: "current.svg",
              ),
              const SizedBox(height: 12),
              _SmallDataProfileItem(
                value: synchroData?.connectorMain?.power ?? "-",
                label: S.current.profile_power,
                width: smallSize,
                height: smallSize,
                colors: greenColors,
                iconName: "power.svg",
              ),
            ],
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            children: [
              _SmallDataProfileItem(
                value: synchroData?.connectorMain?.voltage ?? "-",//电压显示部件
                label: S.current.profile_voltage,
                width: smallSize,
                height: smallSize - 12,
                colors: greenColors,
                iconName: "voltaga.svg",
              ),
              const SizedBox(height: 12),
              _SmallDataProfileItem(
                  // value: chargingTime,
                  value: _chargingTimeUpdate,
                  label: S.current.profile_total_time,
                  width: smallSize,
                  height: smallSize,
                  colors: orangeColors,
                  iconName: "time.svg"),
            ],
          )
        ],
      ),
    );
  }
  String secondsToChargingTime(int time)
  {
    int totalSeconds = time;
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    String timeString = '${hours.toString()}:${minutes.toString()}:${seconds.toString()}';
    // String timeString = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    print(timeString); // 输出：01:02:03
    return timeString;
  }
  @override
  bool get wantKeepAlive => true;
static String oldChargingTime="0";
  static int oldTime=0;
  String get chargingTime {
   // final chargeStatus = synchroStatus?.connectorMain?.chargeStatus;
   //  DateTime now = DateTime.now();
   //  int seconds = now.second;
   //  print('当前时间的秒数为：$seconds');
   //  if(seconds-oldTime>=1)
   //    {
   //      oldTime=seconds;
   //
   //  // DateTime currentTime = DateTime.now();
   //  // DateTime targetTime = currentTime.add(Duration(seconds: 1));
   //  //
   //  // if (targetTime.isBefore(currentTime)) {
   //  //   print("时间已经过了一秒");
   //  // } else {
   //  //   print("时间还未过一秒");
   //  // }
   //
   //    }
   //  else
   //    {
   //      if(synchroStatus?.connectorMain?.chargeStatus == 'charging'&& oldChargingTime==(synchroData?.connectorMain?.chargingTime ?? "-"))
   //      {
   //        oldChargingTime=synchroData?.connectorMain?.chargingTime ?? "-";
   //        return "-";
   //      }
   //    }

    return synchroData?.connectorMain?.chargingTime ?? "-";
  }
}

class _Battery extends StatelessWidget {
  final String? chargeStatus;

  const _Battery({required this.chargeStatus, super.key});

  @override
  Widget build(BuildContext context) {
    final isCharge = chargeStatus == "charging";
    final size = context.screenWidth * 0.8;
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Lottie.asset('public/rotate.json',
              animate: isCharge, width: size, height: size),
          Container(//旋转图标内的阴影部分
            width: size / 2,
            height: size / 2,
            decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.all(Radius.circular(size / 2)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF85A1FF),
                    // 阴影的颜色
                    offset: Offset(0, 10),
                    // 阴影与容器的距离
                    blurRadius: 45.0,
                    // 高斯的标准偏差与盒子的形状卷积。
                    spreadRadius: 0.0,
                  )
                ]),
          ),
          Container(//充电电池图标
            margin: const EdgeInsets.only(bottom: 20),
            child: Lottie.asset(
              'public/data.lottie',
              animate: isCharge,
              width: 100,
              height: 100,
              decoder: customDecoder,
            ),
          ),
          Container(//充电状态提示文本
              margin: const EdgeInsets.only(top: 60),
              child: Text(chargeStatueText))
        ],
      ),
    );
  }

  String get chargeStatueText {
    if (chargeStatus == null) {
      return "-";
    }
    return switch (chargeStatus) {
      "idle" => S.current.charge_status_idle,
      "reserve" => S.current.charge_status_reserve,
      "wait" => S.current.charge_status_wait,
      "charging" => S.current.charge_status_charging,
      "finish" => S.current.charge_status_finish,
      "safeFault" => S.current.charge_status_safe_fault,
      "suspendN" => S.current.charge_status_suspend_N,
      "other" => S.current.charge_status_other,
      _ => S.current.charge_status_any(chargeStatus!)
    };
  }

  Future<LottieComposition?> customDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(bytes, filePicker: (files) {
      return files.firstWhereOrNull(
          (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'));
    });
  }
}

class _ChargeSwitch extends StatelessWidget {
  final bool isLoading;
  final bool isCharge;
  final VoidCallback onClick;

  const _ChargeSwitch(
      {required this.isLoading,
      required this.isCharge,
      required this.onClick,
      super.key});

  @override
  Widget build(BuildContext context) {
    const size = 100.0;//充电按钮开关
    return isLoading
        ? const GPLoadingWidget(
            size: size,
          )
        : Ink(
            child: InkWell(
              onTap: onClick,
              child: isCharge
                  ? const GPAssetImageWidget(
                      "ic_device_on.png",
                      width: size,
                      height: size,
                    )
                  : const GPAssetImageWidget(
                      "ic_device_off.png",
                      width: size,
                      height: size,
                    ),
            ),
          );
  }
}

class _SmallDataProfileItem extends StatelessWidget {
  final List<Color> colors;
  final double width;
  final double height;
  final String label;
  final String value;
  final String iconName;

  const _SmallDataProfileItem(
      {required this.width,
      required this.height,
      required this.colors,
      required this.label,
      required this.value,
      required this.iconName,
      super.key});

  @override
  Widget build(BuildContext context) {
    return _DataProfileItem(
      colors: colors,
      width: width,
      height: height,
      label: label,
      value: value,
      icon: Positioned(
        top: height - 26,
        left: width - 26,
        child: Container(
          height: 30,//充电部件右下角图标
          width: 30,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white),
          child: Center(
              child: GPAssetSvgWidget(
            iconName,
            width: 20,
            height: 20,
          )),
        ),
      ),
    );
  }
}

class _DataProfileItem extends StatelessWidget {
  final List<Color> colors;
  final double width;
  final double height;
  final String label;
  final String value;
  final Widget? icon;

  const _DataProfileItem(
      {required this.width,
      required this.height,
      required this.colors,
      required this.label,
      required this.value,
      this.icon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),//部件渐变色
          gradient: LinearGradient(
              //渐变位置
              begin: Alignment.topLeft, //右上
              end: Alignment.bottomRight, //左下
              stops: const [0.0, 1.0], //[渐变起始点, 渐变结束点]
              //渐变颜色[始点颜色, 结束颜色]
              colors: colors)),
      child: Stack(
        children: [
          Positioned(
              child: Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 0, 0),//参数部件文字位置
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      TextStyle(color: context.onSurfaceVariant, fontSize: 12),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          )),
          if (icon != null) icon!
        ],
      ),
    );
  }
}

class _SmallProfileIcon extends StatelessWidget {
  final String icon;

  const _SmallProfileIcon({required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white),
      child: Center(child: GPAssetSvgWidget(icon)),
    );
  }
}
