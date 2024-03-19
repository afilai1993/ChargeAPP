import 'dart:async';

import 'package:chargestation/component/button.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/infrastructure/dispose.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';

class AuthVerificationController with ChangeNotifier, DiagnosticableTreeMixin {
  final TextEditingController editingController = TextEditingController();

  bool _loading = false;
  int _countDown = -1;

  bool get loading => _loading;
  Timer? _timer;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  int get countDown => _countDown;

  void startTimeCount() {
    _timer?.cancel();
    _countDown = 60;
    notifyListeners();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (--_countDown <= 0) {
        _timer?.cancel();
        _timer = null;
      }
      notifyListeners();
    });
  }

  void stopTimeCount() {
    _timer?.cancel();
    _timer = null;
  }
}

class AuthVerificationTextField extends StatefulWidget {
  final String? labelText;
  final Widget? prefixIcon;
  final AuthVerificationController controller;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final Function() onRetrieve;

  const AuthVerificationTextField(this.controller,
      {this.labelText,
      this.prefixIcon,
      this.textInputAction,
      this.validator,
      this.keyboardType,
      required this.onRetrieve,
      super.key});

  @override
  State<AuthVerificationTextField> createState() =>
      _AuthVerificationTextFieldState();
}

class _AuthVerificationTextFieldState extends State<AuthVerificationTextField>
    with StateAutoDisposeOwner {
  bool _isShowClear = false;

  @override
  void initState() {
    super.initState();
    _isShowClear = widget.controller.editingController.text.isNotEmpty;
    widget.controller.addListenerInDispose(this, () {
      final now = widget.controller.editingController.text.isNotEmpty;
      if (now != _isShowClear) {
        setState(() {
          _isShowClear = now;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      controller: widget.controller.editingController,
      labelText: widget.labelText,
      prefixIcon: widget.prefixIcon,
      validator: widget.validator,
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
              visible: _isShowClear,
              child: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  widget.controller.editingController.clear();
                },
              )),
          ChangeNotifierProvider.value(
            value: widget.controller,
            child: Consumer<AuthVerificationController>(
              builder: (_, ref, child) => GPFilledButton(
                  isLoading: ref.loading,
                  onPressed: ref.countDown > 0 ? null : widget.onRetrieve,
                  text: ref.countDown > 0
                      ? S.current.count_second(ref.countDown)
                      : S.current.retrieve),
            ),
          )
        ],
      ),
    );
  }
}

class AuthPasswordTextField extends StatefulWidget {
  final String? labelText;
  final Widget? prefixIcon;
  final TextEditingController controller;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;

  const AuthPasswordTextField(this.controller,
      {this.labelText,
      this.prefixIcon,
      this.textInputAction,
      this.validator,
      super.key});

  @override
  State<AuthPasswordTextField> createState() => _AuthPasswordTextFieldState();
}

class _AuthPasswordTextFieldState extends State<AuthPasswordTextField>
    with StateAutoDisposeOwner {
  bool _isPasswordVisible = false;
  bool _isShowClear = false;

  @override
  void initState() {
    super.initState();
    _isShowClear = widget.controller.text.isNotEmpty;
    widget.controller.addListenerInDispose(this, () {
      final now = widget.controller.text.isNotEmpty;
      if (now != _isShowClear) {
        setState(() {
          _isShowClear = now;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      obscureText: !_isPasswordVisible,
      labelText: widget.labelText,
      prefixIcon: widget.prefixIcon,
      validator: widget.validator,
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
              visible: _isShowClear,
              child: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  widget.controller.clear();
                },
              )),
          _isPasswordVisible
              ? IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
        ],
      ),
    );
  }
}

class GeneralAuthTextField extends StatefulWidget {
  final String? labelText;
  final Widget? prefixIcon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool readOnly;

  @override
  State<GeneralAuthTextField> createState() => _GeneralAuthTextFieldState();

  const GeneralAuthTextField({
    super.key,
    this.labelText,
    this.prefixIcon,
    required this.controller,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.autofocus = false,
    this.readOnly = false,
    this.focusNode,
  });
}

class _GeneralAuthTextFieldState extends State<GeneralAuthTextField>
    with StateAutoDisposeOwner {
  bool _isShowClear = false;

  @override
  void initState() {
    super.initState();
    _isShowClear = widget.controller.text.isNotEmpty;
    widget.controller.addListenerInDispose(this, () {
      final now = widget.controller.text.isNotEmpty;
      if (now != _isShowClear) {
        setState(() {
          _isShowClear = now;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      labelText: widget.labelText,
      prefixIcon: widget.prefixIcon,
      validator: widget.validator,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
              visible: _isShowClear,
              child: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  widget.controller.clear();
                },
              )),
        ],
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final FocusNode? focusNode;
  final bool readOnly;

  const AuthTextField(
      {this.controller,
      this.keyboardType,
      this.labelText,
      this.prefixIcon,
      this.textInputAction,
      this.obscureText = false,
      this.suffixIcon,
      this.validator,
      this.autofocus = false,
      this.readOnly = false,
      this.focusNode,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        autofocus: autofocus,
        focusNode: focusNode,
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(borderSide: BorderSide()),
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ));
  }
}
