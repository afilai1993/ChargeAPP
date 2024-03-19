import 'package:chargestation/design.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class IntStateRef with ChangeNotifier, DiagnosticableTreeMixin {
  int? _value;

  IntStateRef({int initialize = 0}) : _value = initialize;

  int? get value => _value;

  set value(int? value) {
    _value = value;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty("intStateRef", value));
  }
}

class BoolStateRef with ChangeNotifier, DiagnosticableTreeMixin {
  bool? _value;

  BoolStateRef({bool? initialize = false}) : _value = initialize;

  bool? get value => _value;

  set value(bool? value) {
    _value = value;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty("boolStateRef", value: value));
  }
}

class StateRef<T> with ChangeNotifier, DiagnosticableTreeMixin {
  T _value;

  StateRef(this._value);

  T get value => _value;

  set value(T value) {
    _value = value;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty("stateRef", value));
  }
}

class RefProvider<T extends ChangeNotifier?> extends StatelessWidget {
  final T ref;
  final Widget Function(
    BuildContext context,
    T value,
    Widget? child,
  ) builder;

  const RefProvider(
    this.ref, {
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: ref, child: Consumer<T>(builder: builder));
  }
}
