library fluent;

import 'package:meta/meta.dart';

import 'dart:async';
import './map.dart';

typedef Map<String, dynamic> EffectHandler(Map<String, dynamic> state, [dynamic args]);

class Fluent {
  static final Fluent fluent = Fluent._();

  Fluent._();

  bool saveHistory = true;

  Map<String, dynamic> state = {};
  
  Map<String, List<EffectHandler>> _effects = {};

  Map<String, StreamController> _subs = {};

  List<Map<String, Map>> hx = List.empty(growable: true);

  static void dispatch(String eventName, List args) {
    List<EffectHandler> mappings = fluent._effects[eventName];
    if (mappings == null) {
      return;
    }
    mappings.forEach((m) {
      List<dynamic> handlerArgs = [fluent.state]..addAll(args);
      Map diffMap = Function.apply(m, handlerArgs);
      fluent.state = diffMap;
      List<String> allPaths = diffMap.findAllPaths();

      List changedKeys =
          allPaths.where((el) => fluent._subs.containsKey(el)).toList();
      changedKeys.forEach((el) {
        StreamController ctrl = fluent._subs[el];
        var val = diffMap.getIn(el);
        ctrl.add(val);
      });

      if (fluent.saveHistory) {
        fluent.hx.add({eventName: diffMap});
      }
    });
  }

  static void regEffect(
      String eventName, EffectHandler handler) {
    if (fluent._effects.containsKey(eventName)) {
      fluent._effects[eventName].add(handler);
    } else {
      fluent._effects[eventName] = List<EffectHandler>()..add(handler);
    }
  }

  static Stream regSub(String path) {
    StreamController controller = fluent._subs[path];
    if (controller == null) {
      controller = StreamController();
      fluent._subs[path] = controller;
    }

    return controller.stream;
  }

  void clearHx() => hx.clear();
}
