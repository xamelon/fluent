library fluent;

import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';

import './map.dart';

typedef FutureOr<Map<String, dynamic>> EffectHandler(Map<String, dynamic> state,
    [dynamic args]);

class Fluent {
  static final Fluent fluent = Fluent._();

  Fluent._();

  bool saveHistory = true;

  Map<String, dynamic> state = {};

  Map<String, EffectHandler> _effects = {};

  Map<String, StreamController> _subs = {};

  List<Map<String, Map>> hx = List.empty(growable: true);

  static void _applyNewState(String eventName, Map<String, dynamic> diffMap) {
    assert(diffMap != null, "Effect fn must return new state map");

    List<String> changedKeys = fluent.state.diff(diffMap).findAllPaths();
    fluent.state = diffMap;

    if (changedKeys != null && changedKeys.length > 0) {
      changedKeys.where((e) => fluent._subs[e] != null).forEach((el) {
        StreamController ctrl = fluent._subs[el];
        var val = diffMap.getIn(el);
        ctrl.add(val);
      });
    }

    if (fluent.saveHistory) {
      fluent.hx.add({eventName: diffMap});
    }
  }

  static void dispatch(String eventName, List args) {
    EffectHandler handler = fluent._effects[eventName];
    if (handler == null) {
      return;
    }

    Map<String, dynamic> newState = jsonDecode(jsonEncode(fluent.state));
    var diffMap = Function.apply(
        handler,
        [
          newState,
        ]..addAll(args));

    if (diffMap is Future) {
      Future<Map<String, dynamic>> diffMapFuture = diffMap;
      diffMapFuture.then((Map<String, dynamic> newState) {
        _applyNewState(eventName, newState);
      });
    } else {
      _applyNewState(eventName, diffMap);
    }
  }

  static void regEffect(String eventName, EffectHandler handler) {
    fluent._effects[eventName] = handler;
  }

  void _cleanSubscribers(String path) {
    fluent._subs[path] = null;
  }

  static Stream regSub(String path) {
    StreamController controller = fluent._subs[path];
    if (controller == null) {
      controller = StreamController.broadcast(onCancel: () {
        Fluent.fluent._cleanSubscribers(path);
      });
      fluent._subs[path] = controller;
    }

    if (fluent.state.getIn(path) != null) {
      controller.add(fluent.state.getIn(path));
    }

    return controller.stream;
  }

  void clearHx() => hx.clear();
}
