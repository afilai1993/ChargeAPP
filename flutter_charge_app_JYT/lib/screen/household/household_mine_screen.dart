import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/domain/domain.dart';
import 'package:chargestation/infrastructure/dispose.dart';
import 'package:chargestation/infrastructure/file_factory.dart';
import 'package:collection/collection.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../../infrastructure/infrastructure.dart';

class HouseholdMineScreen extends StatefulWidget {
  const HouseholdMineScreen({super.key});

  @override
  State<HouseholdMineScreen> createState() => _HouseholdMineScreenState();
}

class _HouseholdMineScreenState extends State<HouseholdMineScreen>
    with AutomaticKeepAliveClientMixin, StateAutoDisposeOwner {
  bool isLogin = false;
  String nickname = "";
  String email = "";
  String avatar = "";
  String version = "";

  @override
  void initState() {
    super.initState();
    watchLogin.listen((event) {
      if (isLogin != event) {
        setState(() {
          isLogin = event;
        });
      }
    }).bind(this);

    userStore.watchValue<String>("nickName").listen((event) {
      final current = event ?? "";
      if (nickname != current) {
        setState(() {
          nickname = current;
        });
      }
    }).bind(this);
    userStore.watchValue<String>("avatar").listen((event) {
      final current = event ?? "";
      if (avatar != current) {
        setState(() {
          avatar = current;
        });
      }
    }).bind(this);
    userStore.watchValue<String>("email").listen((event) {
      final current = event ?? "";
      if (email != current) {
        setState(() {
          email = current;
        });
      }
    }).bind(this);
    PackageInfo.fromPlatform()
        .then((res) => {
              setState(() {
                version = res.version;
              })
            })
        .catchError((r) {
      //ignore
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<Widget> menuList = [
      _MineMenuItem(
        iconName: "count.svg",
        name: S.current.charging_statistics,
        onClick: () {
          context.navigateTo("/household/statistic");
        },
      ),


      //导出日志
      _MineMenuItem(
        iconName: "count.svg",
        name: "导出日志",
        onClick: () {
          uiTask
              .options(const UITaskOption(isShowLoading: true))
              .run(Future(() async {
            final encoder = ZipFileEncoder();
            final zipFilePath = (await getShareLogFile()).path;
            //创建zip文件
            encoder.create(zipFilePath);
            //直接扔整个文件夹片进去
            await encoder.addDirectory((await getLogDir()));
            encoder.close();
            return zipFilePath;
          })).onSuccess((result) {
            final fileParts = result!.split(Platform.pathSeparator);
            Share.shareXFiles(
              [XFile(result!)],
              text: fileParts[fileParts.length - 1],
            );
          });
        },
      )
      //导出日志



    ];
    if (isLogin) {
      menuList.addAll([
        const SizedBox(height: 12),
        _MineMenuItem(
          iconName: "edit_3.svg",
          name: S.current.reset_password,
          onClick: () {
            context.navigateTo("/resetPassword");
          },
        ),
        const SizedBox(height: 12),
        _MineMenuItem(
          iconName: "user_x.svg",
          name: S.current.exit_account,
          onClick: logout,
        ),
        const SizedBox(height: 12),
        _MineMenuItem(
          iconName: "delete.svg",
          name: S.current.unregister_account,
          onClick: unregister,
        ),
      ]);
    }
    menuList.add(_MineMenuItem(
      iconName: "count.svg",
      showArrow: false,
      name: S.current.about_app(S.current.app_name),
      rightWidget:
          version.isNotEmpty ? Text("${S.current.version} $version") : null,
      onClick: () {},
    ));
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(S.current.mine),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              context.navigateTo("/settings");
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _MineHeader(
              isLogin: isLogin,
              nickname: nickname,
              email: email,
              avatar: avatar,
              onClick: () {
                context.navigateTo("/profile");
              },
            ),
            const SizedBox(height: 12),
            ...menuList
          ],
        ),
      ),
    );
  }

  void logout() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          final BoolStateRef loading = BoolStateRef();
          return GPMessageDialog(
            message: S.current.msg_confirm_logout,
            loading: loading,
            onConfirm: () {
              dialogContext.uiTask
                  .options(UITaskOption(loadingRef: loading))
                  .run(findCase<UserCase>().logout())
                  .onSuccess((result) {
                showToast(S.current.success_operation);
                dialogContext.navigateBack(null);
              });
            },
            onCancel: () {
              dialogContext.navigateBack();
            },
          );
        });
  }

  void unregister() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          final BoolStateRef loading = BoolStateRef();
          return GPMessageDialog(
            message: S.current.msg_confirm_unregister,
            loading: loading,
            onConfirm: () {
              dialogContext.uiTask
                  .options(UITaskOption(loadingRef: loading))
                  .run(findCase<UserCase>().unregister())
                  .onSuccess((result) {
                showToast(S.current.success_operation);
                dialogContext.navigateBack(null);
              });
            },
            onCancel: () {
              dialogContext.navigateBack();
            },
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class _MineHeader extends StatelessWidget {
  final bool isLogin;
  final String nickname;
  final String email;
  final String avatar;
  final VoidCallback onClick;

  const _MineHeader(
      {required this.isLogin,
      required this.nickname,
      required this.email,
      required this.avatar,
      required this.onClick,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(onTap: onClick, child: GPAvatar(avatar, iconSize: 86)),
        const SizedBox(
          width: 12,
        ),
        if (isLogin)
          Expanded(
            child: SizedBox(
              height: 86,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nickname,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    email,
                    style: TextStyle(color: context.onSurfaceVariant),
                  )
                ],
              ),
            ),
          ),
        if (!isLogin)
          Expanded(
            child: GestureDetector(
              onTap: onClick,
              child: SizedBox(
                height: 86,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.current.please_login,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (isLogin)
          IconButton(
              onPressed: onClick,
              icon: const GPAssetSvgWidget(
                "edit.svg",
                width: 15,
                height: 15,
              ))
      ],
    );
  }
}

class _MineMenuItem extends StatelessWidget {
  final String iconName;
  final String name;
  final VoidCallback onClick;
  final Widget? rightWidget;
  final bool showArrow;

  const _MineMenuItem(
      {required this.iconName,
      required this.name,
      required this.onClick,
      this.rightWidget,
      this.showArrow = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      GPAssetSvgWidget(iconName),
      const SizedBox(
        width: 8,
      ),
      Expanded(child: Text(name)),
    ];
    if (rightWidget != null) {
      children.add(const SizedBox(
        width: 8,
      ));
      children.add(rightWidget!);
    }

    if (showArrow) {
      children.add(const SizedBox(
        width: 8,
      ));
      children.add(const RightArrowIcon());
    }

    return Ink(
      decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: children,
          ),
        ),
      ),
    );
  }
}
