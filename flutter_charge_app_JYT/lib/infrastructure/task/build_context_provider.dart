part of 'ui_task.dart';

abstract class BuildContextProvider {
  BuildContext? get context;

  bool get mounted;
}

class DirectBuildContextProvider implements BuildContextProvider {
  @override
  final BuildContext? context;
  @override
  final bool mounted = true;

  DirectBuildContextProvider(this.context);
}

class StateBuildContextProvider implements BuildContextProvider {
  final State state;

  StateBuildContextProvider(this.state);

  @override
  BuildContext? get context {
    if (state.mounted) {
      return state.context;
    }
    return null;
  }

  @override
  bool get mounted => state.mounted;
}

extension BuildContextByProviderEx on BuildContext? {
  BuildContextProvider createBuildContextProvider() =>
      DirectBuildContextProvider(this);
}

extension StateByProviderEx on State {
  BuildContextProvider createBuildContextProvider() =>
      StateBuildContextProvider(this);
}
