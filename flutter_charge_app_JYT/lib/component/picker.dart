import 'package:chargestation/design.dart';
import 'package:wheel_slider/wheel_slider.dart';

class TimerPicker extends StatelessWidget {
  final int hour;
  final int minute;
  final int second;
  final Function(int, int, int) onValueChanged;

  const TimerPicker(
      {required this.hour,
      required this.minute,
      required this.second,
      required this.onValueChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          const SizedBox(
            width: 12,
          ),
          Expanded(
              child: NumberPicker(
            minValue: 0,
            maxValue: 23,
            initValue: hour,
            onValueChanged: (value) {
              onValueChanged(value, minute, second);
            },
          )),
          Text("时"),
          Expanded(
              child: NumberPicker(
            minValue: 0,
            maxValue: 59,
            initValue: minute,
            onValueChanged: (value) {
              onValueChanged(hour, value, second);
            },
          )),
          Text("分"),
          Expanded(
              child: NumberPicker(
            minValue: 0,
            maxValue: 59,
            initValue: second,
            onValueChanged: (value) {
              onValueChanged(hour, minute, value);
            },
          )),
          Text("秒"),
          const SizedBox(
            width: 12,
          )
        ],
      ),
    );
  }
}

class CustomSinglePicker extends StatelessWidget {
  final int selectedIndex;
  final List<Widget> children;
  final Function(dynamic) onValueChanged;

  const CustomSinglePicker(
      {required this.selectedIndex,
      required this.children,
      required this.onValueChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        WheelSlider.customWidget(
          pointerWidth: 0,
          verticalListWidth: double.infinity,
          listWidth: double.infinity,
          enableAnimation: false,
          horizontal: false,
          totalCount: children.length,
          initValue: selectedIndex,
          isInfinite: false,
          scrollPhysics: const BouncingScrollPhysics(),
          onValueChanged: (val) {
            onValueChanged(val);
          },
          hapticFeedbackType: HapticFeedbackType.vibrate,
          showPointer: false,
          itemSize: 40,
          children: children,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 40),
          color: context.outlineColor,
          width: 100,
          height: 1,
        ),
        Container(
          margin: const EdgeInsets.only(top: 40),
          color: context.outlineColor,
          width: 100,
          height: 1,
        ),
      ],
    );
  }
}

class NumberPicker extends StatelessWidget {
  final int maxValue;
  final int minValue;
  final int initValue;
  final Function(int value) onValueChanged;

  const NumberPicker(
      {required this.minValue,
      required this.maxValue,
      required this.initValue,
      required this.onValueChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    final totalCount = maxValue - minValue + 1;
    return CustomSinglePicker(
      selectedIndex: initValue - minValue,
      children: List.generate(
          totalCount,
          (index) => Center(
                child: Text(
                  "${index + minValue}",
                  style: TextStyle(
                    color: initValue == index + minValue
                        ? context.primaryColor
                        : null,
                  ),
                ),
              )),
      onValueChanged: (val) {
        onValueChanged(val + minValue);
      },
    );
  }
}
