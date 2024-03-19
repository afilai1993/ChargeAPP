part of 'eventbus.dart';

abstract class EventReceiver {
  void receive(Event event);
}

class _StreamEventReceiver implements EventReceiver {
  final MultiStreamController<Event> controller;
  final bool Function(Event event)? where;

  _StreamEventReceiver(this.controller, this.where);

  @override
  void receive(Event event) {
    if (where?.call(event) ?? true) {
      controller.add(event);
    }
  }
}
