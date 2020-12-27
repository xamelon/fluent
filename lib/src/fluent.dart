library fluent;

import 'dart:async';

import './mapping.dart';
import './map.dart';

class Fluent {
  Map<String, dynamic> state = {};

  Map<String, List<Mapping>> effects = {};

  Map<String, StreamController> subs = {};

  void dispatch(String eventName, List args) {
    List<Mapping> mappings = effects[eventName];
    mappings.forEach((m) {
        List<dynamic> handlerArgs = m.args.map((a) => state.getIn(a)).toList()
        ..addAll(args);
        Map diffMap = Function.apply(m.handler, handlerArgs);
        
        state.addAll(diffMap);
        List<String> allPaths = diffMap.findAllPaths();
        List changedKeys = allPaths.where((el) => subs.containsKey(el)).toList();
        print("changed keys: $changedKeys");
        changedKeys.forEach((el) {
            StreamController ctrl = subs[el];
            var val = diffMap.getIn(el);
            ctrl.add(val);
        });
    });
  }

  void regEffect(String eventName, List<String> args,
      Map<String, dynamic> Function([dynamic args]) handler) {
    if (effects.containsKey(eventName)) {
      effects[eventName].add(Mapping(args, handler));
    } else {
      effects[eventName] = List<Mapping>()..add(Mapping(args, handler));
    }
  }

  Stream regSub(String path) {
    StreamController controller = subs[path];
    if(controller == null) {
      controller = StreamController();
      subs[path] = controller;
    }

    return controller.stream;
  }

  
  
}
