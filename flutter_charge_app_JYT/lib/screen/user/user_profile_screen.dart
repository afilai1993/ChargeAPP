import 'dart:io';

import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/domain/domain.dart';
import 'package:chargestation/infrastructure/dispose.dart';
import 'package:image_picker/image_picker.dart';

import '../../infrastructure/infrastructure.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(S.current.user_center),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _UserProfileItemWidget(
              name: S.current.avatar,
              onClick: updateAvatar,
              child: StreamBuilder(
                  stream: userStore.watchValue<String>("avatar"),
                  builder: (_, snap) {
                    return Container(
                      alignment: Alignment.centerRight,
                      child: GPAvatar(
                        snap.data ?? "",
                        iconSize: 36,
                      ),
                    );
                  }),
            ),
            const GPDivider(),
            _UserProfileItemWidget(
              name: S.current.user_name,
              onClick: editNickname,
              child: StreamBuilder(
                  stream: userStore.watchValue<String>("nickName"),
                  builder: (_, snap) {
                    return _UserProfileTextValueWidget(snap.data ?? "");
                  }),
            ),
            const GPDivider(),
            _UserProfileItemWidget(
              name: S.current.email,
              onClick: () {
                context.navigateTo("/user/editEmail");
              },
              child: StreamBuilder(
                  stream: userStore.watchValue<String>("email"),
                  builder: (_, snap) {
                    return _UserProfileTextValueWidget(
                      snap.data ?? "",
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void updateAvatar() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(),
        builder: (innerContext) {
          void pick(ImageSource source) async {
            innerContext.navigateBack();
            final ImagePicker _picker = ImagePicker();
            final pickedFile = await _picker.pickImage(
              source: source,
              imageQuality: 50,
            );
            if (pickedFile != null) {
              // ignore: use_build_context_synchronously
              context.uiTask
                  .run(findCase<UserCase>().updateAvatar(File(pickedFile.path)))
                  .onSuccess((result) {
                showToast(S.current.success_update);
              });
            }
          }

          return BottomMenu(
            children: [
              BottomMenuItem(S.current.pick_in_camera, onClick: () {
                pick(ImageSource.camera);
              }),
              BottomMenuItem(S.current.pick_in_gallery, onClick: () {
                pick(ImageSource.gallery);
              })
            ],
          );
        });
  }

  void editNickname() {
    showDialog(
        context: context,
        builder: (context) {
          final ref = BoolStateRef();
          final textEditingController =
              TextEditingController(text: userStore.getValue("nickName"));
          return EditNicknameDialog(
            controller: textEditingController,
            loading: ref,
            formKey: GlobalKey<FormState>(),
            onConfirm: (text) {
              context.uiTask
                  .options(UITaskOption(loadingRef: ref))
                  .run(findCase<UserCase>().updateNickname(text))
                  .onSuccess((result) {
                showToast(S.current.success_operation);
                context.navigateBack();
              });
            },
            onCancel: () {
              context.navigateBack();
            },
          );
        });
  }
}

class _UserProfileItemWidget extends StatelessWidget {
  final String name;
  final bool showArrow;
  final Widget child;
  final Function()? onClick;

  const _UserProfileItemWidget(
      {super.key,
      required this.name,
      this.showArrow = true,
      this.onClick,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: context.backgroundColor,
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(name),
              Expanded(child: child),
              if (showArrow) const Icon(Icons.keyboard_arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}

class _UserProfileTextValueWidget extends StatelessWidget {
  final String value;

  const _UserProfileTextValueWidget(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: TextAlign.right,
      style: TextStyle(color: context.onSurfaceVariant),
    );
  }
}

class EditNicknameDialog extends StatefulWidget {
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final BoolStateRef loading;
  final Function(String) onConfirm;
  final Function() onCancel;

  const EditNicknameDialog(
      {required this.controller,
      required this.formKey,
      required this.loading,
      required this.onConfirm,
      required this.onCancel,
      super.key});

  @override
  State<EditNicknameDialog> createState() => _EditNicknameDialogState();
}

class _EditNicknameDialogState extends State<EditNicknameDialog>
    with StateAutoDisposeOwner {
  bool showClear = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListenerInDispose(this, () {
      final nowClear = widget.controller.text.isNotEmpty;
      if (showClear != nowClear) {
        setState(() {
          showClear = nowClear;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GPAlertDialog(
      title: GPDialogTitle(S.current.edit_nickname),
      loading: widget.loading,
      content: Form(
        key: widget.formKey,
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: context.outlineColor,
            border: const OutlineInputBorder(borderSide: BorderSide()),
            labelText: S.current.user_name,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
      ),
      onConfirm: () {
        if (widget.formKey.currentState?.validate() == true) {
          widget.onConfirm(widget.controller.text);
        }
      },
      onCancel: widget.onCancel,
    );
  }
}
