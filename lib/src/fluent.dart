library fluent;

import 'dart:async';

import './mapping.dart';
import './map.dart';

class Fluent {

  static final Fluent fluent = Fluent._();
  
  Fluent._();

  bool saveHistory = true;
  
  Map<String, dynamic> state = {};

  Map<String, List<Mapping>> _effects = {};

  Map<String, StreamController> _subs = {};

  List<Map<String, Map>> hx = List.empty(growable: true);
  
  static void dispatch(String eventName, List args) {
    List<Mapping> mappings = fluent._effects[eventName];
    if(mappings == null) {
      return;
    }
    mappings.forEach((m) {
        List<dynamic> handlerArgs = m.args.map((a) {
            return fluent.state.getIn(a);
        }).toList()
        ..addAll(args);
        Map diffMap = Function.apply(m.handler, handlerArgs);
        fluent.state.addAll(diffMap);
        List<String> allPaths = diffMap.findAllPaths();
        
        List changedKeys = allPaths.where((el) => fluent._subs.containsKey(el)).toList();
        changedKeys.forEach((el) {
            StreamController ctrl = fluent._subs[el];
            var val = diffMap.getIn(el);
            ctrl.add(val);
        });

        if(fluent.saveHistory) {
          fluent.hx.add({eventName: diffMap});
        }
    });
  }
  
  static void regEffect(String eventName, List<String> args,
      Map<String, dynamic> Function([dynamic args]) handler) {
    if (fluent._effects.containsKey(eventName)) {
      fluent._effects[eventName].add(Mapping(args, handler));
    } else {
      fluent._effects[eventName] = List<Mapping>()..add(Mapping(args, handler));
    }
  }

  static Stream regSub(String path) {
    StreamController controller = fluent._subs[path];
    if(controller == null) {
      controller = StreamController();
      fluent._subs[path] = controller;
    }

    return controller.stream;
  }

  void clearHx() => hx.clear();

}
