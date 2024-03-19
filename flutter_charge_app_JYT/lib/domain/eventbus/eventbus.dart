import 'dart:async';

import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:collection/collection.dart';



part 'event.dart';

part 'event_receiver.dart';

final EventBus serviceEventBus = EventBus();

class EventBus {
  final List<EventReceiver> _eventReceivers = [];

  void registerReceiver(EventReceiver receiver) {
    if (_eventReceivers.contains(receiver)) {
      return;
    }
    _eventReceivers.add(receiver);
  }

  void unregisterReceiver(EventReceiver receiver) {
    _eventReceivers.remove(receiver);
  }

  void post(Event event) {
    for (var receiver in _eventReceivers) {
      receiver.receive(event);
    }
  }

  Stream<Event> stream({bool Function(Event event)? where}) =>
      Stream.multi((controller) {
        final receiver = _StreamEventReceiver(controller, where);
        registerReceiver(receiver);
        controller.onCancel = () {
          unregisterReceiver(receiver);
        };
      });
}
