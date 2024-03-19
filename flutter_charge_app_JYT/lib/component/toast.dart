import 'dart:async';

import 'package:chargestation/design.dart';
import 'package:chargestation/route/router.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as native_toast;

void showToast(message) {
  //native_toast.Fluttertoast.showToast(msg: message);
  final context = navigatorKey.currentContext;
  if (context == null) {
    return;
  }
  _Toast.of(context).showToast(message);
}

TransitionBuilder toastBuilder() => (context, child) {
      return _Toast(
        child: child!,
      );
    };

class _Toast extends StatefulWidget {
  final Widget child;

  const _Toast({super.key, required this.child});

  @override
  State<_Toast> createState() => _ToastState();

  static _ToastState of(BuildContext context) {
    return context.findAncestorStateOfType<_ToastState>()!;
  }
}

class _ToastState extends State<_Toast> {
  final GlobalKey<OverlayState> _overlayKey = GlobalKey();
  OverlayEntry? _entry;
  TextToastController? textToastController;
  Timer? timer;
  Timer? fadeTimer;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          key: _overlayKey,
          initialEntries: <OverlayEntry>[
            OverlayEntry(
              builder: (BuildContext ctx) {
                return widget.child;
              },
            ),
          ],
        ));
  }

  void showToast(String message) {
    final overlayState = _overlayKey.currentState;
    if (overlayState == null) {
      return;
    }
    final isInserted = textToastController == null;
    textToastController ??= TextToastController();
    textToastController!.addMessage(message);
    if (isInserted) {
      _entry = OverlayEntry(builder: (overlayContext) {
        return _TextToast(controller: textToastController!);
      });
      overlayState.insert(_entry!);
    }
    fadeTimer?.cancel();
    timer?.cancel();
    timer = Timer(_toastDuration, () {
      fadeTimer = Timer(_fadeDuration, () {
        timer?.cancel();
        timer = null;
        fadeTimer?.cancel();
        fadeTimer = null;
        _entry!.remove();
        _entry = null;
        textToastController = null;
      });
    });
  }
}

const _fadeDuration = Duration(milliseconds: 350);
const _toastDuration = Duration(milliseconds: 1500);

class _TextToast extends StatefulWidget {
  final TextToastController controller;

  const _TextToast({super.key, required this.controller});

  @override
  State<_TextToast> createState() => _TextToastState();
}

class _TextToastState extends State<_TextToast>
    with SingleTickerProviderStateMixin {
  /// Controller to start and hide the animation
  AnimationController? _animationController;
  late Animation _fadeAnimation;
  String currentText = "";
  Timer? timer;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: _fadeDuration,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController!, curve: Curves.easeIn);
    widget.controller.addListener(onChanged);
    currentText = widget.controller.messageList.removeAt(0);
    super.initState();
    showIt();
  }

  showIt() {
    _animationController!.forward();
    timer?.cancel();
    timer = Timer(_toastDuration, () {
      hideIt();
    });
  }

  hideIt() {
    _animationController!.reverse();
  }

  @override
  void deactivate() {
    timer?.cancel();
    _animationController!.stop();
    widget.controller.removeListener(onChanged);
    super.deactivate();
  }

  @override
  void dispose() {
    timer?.cancel();
    _animationController?.dispose();
    widget.controller.removeListener(onChanged);
    super.dispose();
  }

  void onChanged() {
    setState(() {
      currentText = widget.controller.messageList.removeAt(0);
      showIt();
    });
  }

  @override
  Widget build(BuildContext context) {
    var bottom = 55.0;
    final softKeyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    if (softKeyboardHeight > 0) {
      bottom += softKeyboardHeight;
    } else {
      bottom += MediaQuery.paddingOf(context).bottom;
    }
    return Positioned(
      bottom: bottom,
      left: 24.0,
      right: 24.0,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: IgnorePointer(
          ignoring: false,
          child: FadeTransition(
            opacity: _fadeAnimation as Animation<double>,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(
                      color: context.inverseSurface,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Text(
                      currentText,
                      style: TextStyle(color: context.onInverseSurface),
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextToastController with ChangeNotifier {
  List<String> messageList = [];

  TextToastController();

  void addMessage(String message) {
    messageList.add(message);
    notifyListeners();
  }
}
